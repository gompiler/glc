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
    $nl                                 { tok TNewLine }
    $white+                             ;
    "//".*                              ;
    "//*".*"//*"                        ;
    "+"                                 { tok TPlus }
    "-"                                 { tok TMinus }
    "*"                                 { tok TTimes }
    "/"                                 { tok TDiv }
    "%"                                 { tok TMod }
    "&"                                 { tok TLAnd }
    "|"                                 { tok TLOr }
    "^"                                 { tok TLXor }
    ":"                                 { tok TColon }
    ";"                                 { tok TSemicolon }
    "("                                 { tok TLParen }
    ")"                                 { tok TRParen }
    "["                                 { tok TLSquareB }
    "]"                                 { tok TRSquareB }
    "{"                                 { tok TLBrace }
    "}"                                 { tok TRBrace }
    "="                                 { tok TAssn }
    ","                                 { tok TComma }
    "."                                 { tok TDot }
    ">"                                 { tok TGt }
    "<"                                 { tok TLt }
    "!"                                 { tok TNot }
    "<<"                                { tok TLeftS }
    ">>"                                { tok TRightS }
    "&^"                                { tok TLAndNot }
    "+="                                { tok TIncA }
    "-="                                { tok TDIncA }
    "*="                                { tok TMultA }
    "/="                                { tok TDivA }
    "%="                                { tok TModA }
    "&="                                { tok TLAndA }
    "|="                                { tok TLOrA }
    "^="                                { tok TLXorA }
    "&&"                                { tok TAnd }
    "||"                                { tok TOr }
    "<-"                                { tok TRecv }
    "++"                                { tok TInc }
    "--"                                { tok TDInc }
    "=="                                { tok TEq }
    "!="                                { tok TNEq }
    "<="                                { tok TLEq }
    ">="                                { tok TGEq }
    ":="                                { tok TDeclA }
    "<<="                               { tok TLeftSA }
    ">>="                               { tok TRightSA }
    "&^="                               { tok TLAndNotA }
    "..."                               { tok TLdots }
    break                               { tok TBreak }
    case                                { tok TCase }
    chan                                { tok TChan }
    const                               { tok TConst }
    continue                            { tok TContinue }
    default                             { tok TDefault }
    defer                               { tok TDefer }
    else                                { tok TElse }
    fallthrough                         { tok TFallthrough }
    for                                 { tok TFor }
    func                                { tok TFunc }
    go                                  { tok TGo }
    goto                                { tok TGoto }
    if                                  { tok TIf }
    import                              { tok TImport }
    interface                           { tok TInterface }
    map                                 { tok TMap }
    package                             { tok TPackage }
    range                               { tok TRange }
    return                              { tok TReturn }
    select                              { tok TSelect }
    struct                              { tok TStruct }
    switch                              { tok TSwitch }
    type                                { tok TType }
    var                                 { tok TVar }
    print                               { tok TPrint }
    println                             { tok TPrintln }
    append                              { tok TAppend }
    len                                 { tok TLen }
    cap                                 { tok TCap }
    0$octal+                            { tokM TOctVal }
    0[xX]$hex+                          { tokM THexVal }
    $digit+                             { tokM TDecVal }
    $digit*\.$digit+                    { tokRInp TFloatVal }
    $alpha [$alpha $digit \_]*          { tokM TIdent }
    <0> \' @string \'                   { tokCInp TRuneVal }
    <0> \" @string* \"                  { tokM TStringVal }
    <0> \` @string* \`                  { tokM TRStringVal }

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
                | TNewLine -- For post-processing semicolon insertion
                | TEOF
                deriving (Eq, Show)
                
alexEOF :: Alex Token
alexEOF = do
        (p, _, _, _) <- alexGetInput
        return (Token p TEOF)

-- | tokM is a monad wrapper, this deals with consumming strings from the input string and wrappin tokens in a monad
tokM :: Monad m => ([a] -> InnerToken) -> (AlexPosn, b, c, [a]) -> Int -> m Token
tokM f (p, _, _, s) len = return (Token p (f (take len s)))

-- | Feed function to tokM
tok :: Monad m => InnerToken -> (AlexPosn, b, c, [a]) -> Int -> m Token
tok x = tokM $ const x

-- | Char
tokCInp :: Monad m => (t -> InnerToken) -> (AlexPosn, b, c, [t]) -> Int -> m Token
-- Input will *always* be of length 3 as we only feed '@string' to this, where @string is one character corresponding to the string macro
tokCInp x = tokM $ x . (!!1) -- Take index 1 of the string that should be 'C' where C is a char

tokRInp :: (Monad m, Read t) => (t -> InnerToken) -> (AlexPosn, b, c, [Char]) -> Int -> m Token
-- | tokInp but pass s through read (for things that aren't strings)
tokRInp x = tokM $ x . read
}
