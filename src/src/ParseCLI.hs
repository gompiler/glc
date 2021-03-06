module ParseCLI
  ( Cmd(..)
  , Inp(..)
  , CmdI(..)
  , inpToIOStr
  , cmdParser
  ) where

import           Options.Applicative

-- | Inp: type representing input via file or stdin
-- The user is able to choose which it wants to use via command line arg
data Inp
  = FileInp FilePath
  | StdInp

-- | Cmd: type specifying mode
data Cmd
  = Scan
  | Tokens
  | Parse
  | Pretty
  | PrettyInvar
  | Symbol
  | Typecheck
  | IR
  | Codegen
  | PrettyTypecheck
  | PrettyResource
  | CheckedDataP
  | ResourceDataP

-- | CmdI: Cmd + Inp
data CmdI =
  CI Cmd
     Inp

parseFile :: Parser Inp
parseFile =
  FileInp <$>
  strOption
    (long "file-path" <>
     short 'f' <>
     metavar "FILEPATH" <>
     help "Read input (source to be evaluated) from file at FILEPATH")

parseStd :: Parser Inp
parseStd =
  flag'
    StdInp
    (long "stdin" <>
     short 's' <> help "Read input (source to be evaluated) from stdin")

parseSource :: Parser Inp
parseSource = parseFile <|> parseStd

scanParser :: ParserInfo CmdI
scanParser =
  info
    (CI Scan <$> parseSource)
    (fullDesc <>
     progDesc "Outputs OK if lexically correct, or an error message." <>
     header "scan - scans a source file")

tokensParser :: ParserInfo CmdI
tokensParser =
  info
    (CI Tokens <$> parseSource)
    (fullDesc <>
     progDesc "Outputs tokens, one per line, until the end of file." <>
     header "tokens - outputs tokens from the scanner for a source file")

parseParser :: ParserInfo CmdI
parseParser =
  info
    (CI Parse <$> parseSource)
    (fullDesc <>
     progDesc "Outputs OK if syntactically correct, or an error message." <>
     header "parse - parses a source file")

prettyParser :: ParserInfo CmdI
prettyParser =
  info
    (CI Pretty <$> parseSource)
    (fullDesc <>
     progDesc "Outputs pretty printed code from the AST to stdout." <>
     header "pretty - pretty print a source file")

prettyInvarParser :: ParserInfo CmdI
prettyInvarParser =
  info
    (CI PrettyInvar <$> parseSource)
    (progDesc "Checks that the prettifier and parsers are invariant.")

prettyTypecheckP :: ParserInfo CmdI
prettyTypecheckP = info (CI PrettyTypecheck <$> parseSource) briefDesc

prettyResourceP :: ParserInfo CmdI
prettyResourceP = info (CI PrettyResource <$> parseSource) briefDesc

checkedDataP :: ParserInfo CmdI
checkedDataP = info (CI CheckedDataP <$> parseSource) briefDesc

resourceDataP :: ParserInfo CmdI
resourceDataP = info (CI ResourceDataP <$> parseSource) briefDesc

symbolParser :: ParserInfo CmdI
symbolParser =
  info
    (CI Symbol <$> parseSource)
    (fullDesc <>
     progDesc
       "Outputs the symbol table to stdout or an error if the table is incomplete." <>
     header "symbol - output the symbol table of a source file")

typecheckParser :: ParserInfo CmdI
typecheckParser =
  info
    (CI Typecheck <$> parseSource)
    (fullDesc <>
     progDesc "Outputs OK if input type is correct, or an error message." <>
     header "typecheck - typechecks a source file")

irParser :: ParserInfo CmdI
irParser =
  info
    (CI IR <$> parseSource)
    (fullDesc <>
     progDesc "Outputs IR if input type is correct, or an error message." <>
     header "ir - shows low-level IR for a source file")

codegenParser :: ParserInfo CmdI
codegenParser =
  info
    (CI Codegen <$> parseFile)
    (fullDesc <>
     progDesc "Generates equivalent JVM Bytecode in an output file and outputs OK." <>
     header "codegen - generate JVM Bytecode from a source file")

-- Combine all mode parsers into one
cmdParser :: ParserInfo CmdI
cmdParser =
  info
    (hsubparser
       (commandGroup "MODE ((-f|--file-path FILEPATH) | (-s|--stdin))" <>
        command "scan" scanParser <>
        command "tokens" tokensParser <>
        command "parse" parseParser <>
        command "pretty" prettyParser <>
        command "symbol" symbolParser <> command "typecheck" typecheckParser) <|>
     hsubparser
       (commandGroup "MODE ((-f|--file-path FILEPATH))" <>
        command "codegen" codegenParser) <|>
     hsubparser
       (internal <>
        command "prettyinvar" prettyInvarParser <>
        command "prettyt" prettyTypecheckP <>
        command "ir" irParser <>
        command "prettyr" prettyResourceP <>
        command "checked" checkedDataP <>
        command "resource" resourceDataP) <**>
     helper)
    (fullDesc <>
     progDesc "Compiler for goLite" <> header "glc - a compiler for goLite")

inpToIOStr :: Inp -> IO String
inpToIOStr inp =
  case inp of
    FileInp f -> readFile f
    StdInp    -> getContents
