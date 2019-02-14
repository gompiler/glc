{
module Tokens where
}

%wrapper "monad"

-- Macro helper definitions
$digit = 0-9
$alpha = [a-zA-z]

$charesc = [abfnrtv\\\'\"]
$symbol = [\!\#\$\%\^\&\*\+\.\/\<\=\>\?\@\\\^\|\-\~\(\)\,\;\[\]\`\{\}]
$graphic   = [$alpha $symbol $digit \:\"\']

@escape = \\ ($charesc)

@string = $graphic # [\"\\] | " " | @escape

tokens :-

    -- ignore whitespace
    $white+                             ;
    "//".*                              ;
    ":"                                 { tok TColon }
    ";"                                 { tok TSemicolon }
    "("                                 { tok TLParen }
    ")"                                 { tok TRParen }
    "{"                                 { tok TLBrace }
    "}"                                 { tok TRBrace }
    "+"                                 { tok TPlus }
    "-"                                 { tok TMinus }
    "*"                                 { tok TTimes }
    "/"                                 { tok TDiv }
    "="                                 { tok TAsgn }
    ">"                                 { tok TGt }
    "<"                                 { tok TLt }
    "!"                                 { tok TNot }
    "=="                                { tok TEq }
    "!="                                { tok TNEq }
    ">="                                { tok TGEq }
    "<="                                { tok TLEq }
    "&&"                                { tok TAnd }
    "||"                                { tok TOr }
    var                                 { tok TVar }
    float                               { tok TFloat }
    int                                 { tok TInt }
    string                              { tok TString }
    boolean                             { tok TBool }
    if                                  { tok TIf }
    else                                { tok TElse }
    while                               { tok TWhile }
    read                                { tok TRead }
    print                               { tok TPrint }
    true                                { tok TTrue }
    false                               { tok TFalse }
    0 | 1-9$digit*                      { tokRInp TIntVal }
    00* | 0$digit+                      { tok TInvalidI }
    000*\.$digit* | 0$digit+\.$digit*   { tok TInvalidF }
    $digit+\.$digit+                    { tokRInp TFloatVal }
    $alpha [$alpha $digit \_]*          { tokInp TIdent }
    <0> \" @string* \"                  { tokInp TStringVal }

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
                | TLAnd
                | TLOr
                | TLXor
                | TLeftS
                | TRightS
                | TLAndNot
                | TIncAssn
                | TDIncAssn
                | TMultAssn
                | TDivAssn
                | TModAssn
                | TLAndAssn
                | TLOrAssn
                | TLXorAssn
                | TLeftSAssn
                | TRightSAssn
                | TLAndNotAssn
                | TAnd
                | TOr
                | TRecv
                | TInc
                | TDInc
                | TEq
                | TLt
                | TGt
                | TAssn
                | TNot
                | TNEq
                | TLEq
                | TGEq
                | TDeclAssn
                | TLdots
                | TLParen
                | TRParen
                | TLSquareB
                | TRSquareB
                | TRBrace
                | TLBrace
                | TRBrace
                | TComma
                | TDot
                | TColon
                | TSemicolon
                | TIntVal Int
                | TRuneVal Char
                | TFloatVal Float
                | TStringVal String
                | TRStringVal String
                | TIdent String
                | TEOF
                deriving (Eq, Show)

alexEOF = do
        (p, _, _, _) <- alexGetInput
        return (Token p TEOF)

-- | tokM is a monad wrapper, this deals with consumming strings from the input string and wrappin tokens in a monad
tokM f (p, _, _, s) len = return (Token p (f (take len s)))

-- | Feed function to tokM
tok x = tokM (\s -> x)

-- | tok but keep the String value received by matching regex
tokInp x = tokM (\s -> x s)

-- | tokInp but pass s through read (for things that aren't strings)
tokRInp x = tokM (\s -> x (read s))
}
