{
module Tokens where
}

%wrapper "monad"

-- Macro helper definitions
$digit = 0-9
$upper = [A-z]
$lower = [a-z \_]
$alpha = [$upper $lower]

$charesc = [abfnrtv\\\'\"]
$symbol = [\!\#\$\%\^\&\*\+\.\/\<\=\>\?\@\\\^\|\-\~\(\)\,\;\[\]\`\{\}]
$graphic   = [$alpha $symbol $digit \:\"\']

$octal = 0-7
$hex = [$digit A-F a-f]
$nl = [\n \r]

-- Control characters to the right of ^
$ctrl = [$upper \@\[\\\]\^\_]
-- Special ascii characters
@special = \^ $ctrl | NUL | SOH | STX | ETX | EOT | ENQ | ACK | BEL | BS | TAB | LF | VT | FF | CR | SO | SI | DLE | DC1 | DC2 | DC4 | NAK | SYN | ETB | CAN | EM | SUB | ESC | FS | GS | RS | US | SP | DEL

@escape = \\ ($charesc)

@string = $graphic # [\"\\] | " " | @escape | @special

tokens :-

    -- ignore whitespace
    <nl> $nl                            { tokS TSemicolon }
    $white+                             ;
    "//".*                              ;
    "//*".*"//*"                        ;
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
    $digit+                             { tokSM TDecVal }
    $digit*\.$digit+                    { tokRInp TFloatVal }
    $alpha [$alpha $digit \_]*          { tokSM TIdent }
    <0> \' @string \'                   { tokCInp TRuneVal }
    <0> \" @string* \"                  { tokSM TStringVal }
    <0> \` @string* \`                  { tokSM TRStringVal }

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
                | TRuneVal Char
                | TFloatVal Float
                | TStringVal String
                | TRStringVal String -- Raw String
                | TIdent String
                | TEOF
                deriving (Eq, Show)

alexEOF :: Alex Token
alexEOF = do
        (p, _, _, _) <- alexGetInput
        return (Token p TEOF)

-- | tokM is a monad wrapper, this deals with consumming strings from the input string and wrapping tokens in a monad
tokM :: Monad m => ([a] -> InnerToken) -> (AlexPosn, b, c, [a]) -> Int -> m Token
tokM f (p, _, _, s) len = return (Token p (f (take len s)))

-- | Feed function to tokM
tok :: Monad m => InnerToken -> (AlexPosn, b, c, [a]) -> Int -> m Token
tok x = tokM $ const x

-- | Char
-- tokCInp :: Monad m => (t -> InnerToken) -> (AlexPosn, b, c, [t]) -> Int -> m Token
-- Input will *always* be of length 3 as we only feed '@string' to this, where @string is one character corresponding to the string macro
tokCInp x = andBegin (tokM $ x . (!!1)) (getTokenState $ x ' ') -- Take index 1 of the string that should be 'C' where C is a char

-- tokRInp :: (Monad m, Read t) => (t -> InnerToken) -> (AlexPosn, b, c, [Char]) -> Int -> m Token
-- | tokInp but pass s through read (for things that aren't strings)
tokRInp x = andBegin (tokM $ x . read) (getTokenState $ x 0.0)

nlTokens  = [TInc, TDInc, TRParen, TRBrace, TBreak, TContinue, TReturn]

-- | Gets token state for semicolon insertion (either 0 or nl)
getTokenState :: InnerToken -> Int
getTokenState t
  | t `elem` nlTokens  = nl
  | otherwise =
      case t of
        TIdent _        -> nl
        TDecVal _       -> nl
        TOctVal _       -> nl
        THexVal _       -> nl
        TRuneVal _      -> nl
        TFloatVal _     -> nl
        TStringVal _    -> nl
        TRStringVal _   -> nl
        _               -> 0

-- | Wrapper for andBegin/tok
-- TODO: TYPE SIGNATURE
tokS x = andBegin (tokM $ const x) (getTokenState x)

-- | Same thing, but for tokM
-- TODO: TYPE SIGNATURE
tokSM x = andBegin (tokM x) (getTokenState $ x "")
}
