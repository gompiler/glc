{
module TokenGen
( Alex(..)
, AlexPosn(..)
, alex_pos
, alexError
, Token(..)
, InnerToken(..)
, alexMonadScan
, runAlex
, runAlex'
) where
import TokensBase
}


-- Macro helper definitions
$digit = 0-9
$upper = [A-Z]
$lower = [a-z \_]
$alpha = [$upper $lower]

$charesc = [abfnrtv\\]
$symbol = [\!\#\$\%\^\&\*\+\.\/\<\=\>\?\@\^\|\-\~\(\)\,\:\;\[\]\`\{\}]
$graphic   = [$alpha $symbol $digit \"\']

$octal = 0-7
$hex = [$digit A-F a-f]
$nl = [\n \r]

-- Control characters to the right of ^
$ctrl = [$upper \@\[\\\]\^\_]
-- Special ascii characters
@special = \^ $ctrl | NUL | SOH | STX | ETX | EOT | ENQ | ACK | BEL | BS | TAB | LF | VT | FF | CR | SO | SI | DLE | DC1 | DC2 | DC4 | NAK | SYN | ETB | CAN | EM | SUB | ESC | FS | GS | RS | US | SP | DEL

@escape = \\ ($charesc)
@escapestr = \\ \"
@escapec = \\ \'

@rstring = $graphic # [\`] | " " | \\ | @special
@string = $graphic # [\"] | " " | @escape | @escapestr | @special
@char = $graphic # [\'] | " " | @escape | @escapec | @special

@comment = "/*"

tokens :-

    -- ignore whitespace
    <nl> $nl                            { tokS TSemicolon }
    $white                              ;
    "//".*                              ;
    @comment                            { blockComment }
    "+"                                 { tokS TPlus }
    "-"                                 { tokS TMinus }
    "*"                                 { tokS TTimes }
    "/"                                 { tokS TDiv }
    "%"                                 { tokS TMod }
    "&"                                 { tokS TLAnd }
    "|"                                 { tokS TLOr }
    "^"                                 { tokS TLXor }
    ":"                                 { tokS TColon }
    ";"                                 { tokS TSemicolon }
    "("                                 { tokS TLParen }
    ")"                                 { tokS TRParen }
    "["                                 { tokS TLSquareB }
    "]"                                 { tokS TRSquareB }
    "{"                                 { tokS TLBrace }
    "}"                                 { tokS TRBrace }
    "="                                 { tokS TAssn }
    ","                                 { tokS TComma }
    "."                                 { tokS TDot }
    ">"                                 { tokS TGt }
    "<"                                 { tokS TLt }
    "!"                                 { tokS TNot }
    "<<"                                { tokS TLeftS }
    ">>"                                { tokS TRightS }
    "&^"                                { tokS TLAndNot }
    "+="                                { tokS TIncA }
    "-="                                { tokS TDIncA }
    "*="                                { tokS TMultA }
    "/="                                { tokS TDivA }
    "%="                                { tokS TModA }
    "&="                                { tokS TLAndA }
    "|="                                { tokS TLOrA }
    "^="                                { tokS TLXorA }
    "&&"                                { tokS TAnd }
    "||"                                { tokS TOr }
    "<-"                                { tokS TRecv }
    "++"                                { tokS TInc }
    "--"                                { tokS TDInc }
    "=="                                { tokS TEq }
    "!="                                { tokS TNEq }
    "<="                                { tokS TLEq }
    ">="                                { tokS TGEq }
    ":="                                { tokS TDeclA }
    "<<="                               { tokS TLeftSA }
    ">>="                               { tokS TRightSA }
    "&^="                               { tokS TLAndNotA }
    "..."                               { tokS TLdots }
    break                               { tokS TBreak }
    case                                { tokS TCase }
    chan                                { tokS TChan }
    const                               { tokS TConst }
    continue                            { tokS TContinue }
    default                             { tokS TDefault }
    defer                               { tokS TDefer }
    else                                { tokS TElse }
    fallthrough                         { tokS TFallthrough }
    for                                 { tokS TFor }
    func                                { tokS TFunc }
    go                                  { tokS TGo }
    goto                                { tokS TGoto }
    if                                  { tokS TIf }
    import                              { tokS TImport }
    interface                           { tokS TInterface }
    map                                 { tokS TMap }
    package                             { tokS TPackage }
    range                               { tokS TRange }
    return                              { tokS TReturn }
    select                              { tokS TSelect }
    struct                              { tokS TStruct }
    switch                              { tokS TSwitch }
    type                                { tokS TType }
    var                                 { tokS TVar }
    print                               { tokS TPrint }
    println                             { tokS TPrintln }
    append                              { tokS TAppend }
    len                                 { tokS TLen }
    cap                                 { tokS TCap }
    0$octal+                            { tokSM TOctVal }
    0[xX]$hex+                          { tokSM THexVal }
    0 | [1-9]$digit*                    { tokSM TDecVal }
    $digit*\.$digit*                    { tokSM TFloatVal }
    $alpha [$alpha $digit]*             { tokSM TIdent }
    \' @char \'                         { tokSM TRuneVal }
    \" @string* \"                      { tokSM TStringVal }
    \` @rstring* \`                     { tokSM TRStringVal }

{
data Token = Token AlexPosn InnerToken
           deriving (Eq, Show)

-- | InnerToken so that we do not need to include an AlexPosn to each token, rather just include InnerToken in the defn of Token
data InnerToken = TBreak
                | TCase
                | TChan
                | TConst
                | TContinue
                | TDefault
                | TDefer
                | TElse
                | TFallthrough
                | TFor
                | TFunc
                | TGo
                | TGoto
                | TIf
                | TImport
                | TInterface
                | TMap
                | TPackage
                | TRange
                | TReturn
                | TSelect
                | TStruct
                | TSwitch
                | TType
                | TVar
                | TPrint
                | TPrintln
                | TAppend
                | TLen
                | TCap
                | TPlus
                | TMinus
                | TTimes
                | TDiv
                | TMod
                | TLAnd     -- &
                | TLOr      -- |
                | TLXor     -- ^
                | TLeftS    -- <<
                | TRightS   -- >>
                | TLAndNot  -- &^
                | TIncA     -- +=
                | TDIncA    -- -=
                | TMultA    -- *=
                | TDivA     -- /=
                | TModA     -- %=
                | TLAndA    -- &=
                | TLOrA     -- |=
                | TLXorA    -- ^=
                | TLeftSA   -- <<=
                | TRightSA  -- >>=
                | TLAndNotA -- &^=
                | TAnd
                | TOr
                | TRecv
                | TInc
                | TDInc
                | TEq
                | TLt
                | TGt
                | TAssn     -- =
                | TNot
                | TNEq
                | TLEq
                | TGEq
                | TDeclA    -- :=
                | TLdots    -- ...
                | TLParen
                | TRParen
                | TLSquareB
                | TRSquareB
                | TLBrace
                | TRBrace
                | TComma
                | TDot
                | TColon
                | TSemicolon
                | TDecVal String
                | TOctVal String
                | THexVal String
                | TRuneVal String
                | TFloatVal String
                | TStringVal String
                | TRStringVal String -- Raw String
                | TIdent String
                | TEOF
                deriving (Eq, Show)

-- | Custom definition of alexMonadScan to modify the error message with more info
alexMonadScan :: Alex Token
alexMonadScan = do
  inp__ <- alexGetInput
  sc <- alexGetStartCode
  case alexScan inp__ sc of
    AlexEOF -> alexEOF
    AlexError (AlexPn o _ _, _, _, _) -> errGenL o
    AlexSkip inp__' _len -> do
      alexSetInput inp__'
      alexMonadScan
    AlexToken inp__' len action -> do
      alexSetInput inp__'
      action (ignorePendingBytes inp__) len

errGenL :: Int -> Alex a
errGenL o = alexError ("Error: lexical error at ", o)

alexEOF :: Alex Token
alexEOF = do
        (p, _, _, _) <- alexGetInput
        return (Token p TEOF)

blockComment :: AlexInput -> Int -> Alex Token
blockComment _ _ = do
                 inp <- alexGetInput
                 checkBlk inp inp False

-- checkBlk :: AlexInput
--         -> AlexInput -- ^ Where the comment started so we can get position to associate with semicolon insertion
--         -> Bool -> Alex a
checkBlk inp beg@(pos@(AlexPn o _ _), _, _, _) semi =
  maybe
    (alexError ("Error: unclosed block comment at ", o)) matchEnd (alexGetByte inp)
  where
  bToC b = (toEnum (fromIntegral b) :: Char)
  matchEnd (b, inp') = case bToC b of
                        '*'  ->
                            maybe
                                (alexError ("Error: unclosed block comment at ", o))
                                matchEnd2 (alexGetByte inp')
                        '\n' -> checkBlk inp' beg True
                        _    -> checkBlk inp' beg semi
  matchEnd2 (b, inp') = case bToC b of
                         '/' -> do
                             alexSetInput inp'
                             sc <- alexGetStartCode
                             if semi && (sc == nl)
                                then alexSetStartCode 0 >>
                                     return (Token pos TSemicolon)
                                else alexMonadScan
                         _   -> checkBlk inp' beg semi

-- | tokM is a monad wrapper, this deals with consumming strings from the input string and wrapping tokens in a monad
tokM :: ([a] -> InnerToken) -> (AlexPosn, b, c, [a]) -> Int -> Alex Token
tokM f (p, _, _, s) len = return (Token p (f (take len s)))

-- | Feed function to tokM
tok :: InnerToken -> (AlexPosn, b, c, [a]) -> Int -> Alex Token
tok x = tokM $ const x

nlTokens  = [TInc, TDInc, TRParen, TRSquareB, TRBrace, TBreak, TContinue, TFallthrough, TReturn]

-- | Gets token state for semicolon insertion (either 0 or nl)
getTokenState :: InnerToken -> Int
getTokenState t
  | t `elem` nlTokens  = nl
  | otherwise = 0

-- | Wrapper for andBegin/tok
tokS :: InnerToken -> AlexAction Token
tokS x = andBegin (tokM $ const x) (getTokenState x)

-- | Same thing, but for tokM
tokSM :: (String -> InnerToken) -> AlexAction Token
tokSM x = andBegin (tokM x) nl -- All literal values can take optional semicolons
}
