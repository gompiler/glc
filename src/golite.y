{module Parser ( putExit
                , AlexPosn(..)
                , runAlex
                , pId
                , pT
                , pTDecl
                , pTDecls
                , pDec
                , pDecB
                , pFDec
                , pSig
                , pIDecl
                , pPar
                , pRes
                , pStmt
                , pStmts
                , pBStmt
                , pSStmt
                , pIf
                , pElses
                , pEl
                , pE
                , hparse
                , parse)
where
import Scanner
import Data
import ErrorBundle
import System.Exit
import System.IO

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
}

-- Name of parse function generated by Happy
%name hparse
%tokentype { Token }
%monad { Alex } { >>= } { return }
%lexer { lexer } { Token _ TEOF }
%error { parseError }

-- Other partial parsers for testing
%partial pId Idents
%partial pE Expr
%partial pT Type
%partial pEl EIList
%partial pTDecl TopDecl
%partial pTDecls TopDecls
%partial pDec Decl
%partial pDecB DeclBody
%partial pFDec FuncDecl
%partial pSig Signature
%partial pIDecl InnerDecl
%partial pPar Params
%partial pRes Result
%partial pStmt Stmt
%partial pStmts Stmts
%partial pBStmt BlockStmt
%partial pSStmt SimpleStmt
%partial pIf IfStmt
%partial pElses Elses
%partial pSwS SwitchStmt
%partial pSwB SwitchBody
%partial pFor ForStmt

{- Spec: https://golang.org/ref/spec#Operator_precedence -}
%nonassoc ',' {- Lowest precedence, for arrays and expression lists. TODO: DO WE NEED THIS? -}
%left "||"
%left "&&"
%left "==" "!=" '<' "<=" '>' ">="
%left '+' '-' '|' '^'
%left '*' '/' '%' "<<" ">>" '&' "&^"
%nonassoc '!' POS NEG COM {- TODO: SHOULD THIS BE ASSOCIATIVE? -}
%left '[' ']' '(' ')' {- TODO: CHECK PRECEDENCE HERE -}
%left '.' {- TODO: CHECK PRECEDENCE HERE -}

%token
    '+'                                 { Token _ TPlus }
    '-'                                 { Token _ TMinus }
    '*'                                 { Token _ TTimes }
    '/'                                 { Token _ TDiv }
    '%'                                 { Token _ TMod }
    '&'                                 { Token _ TLAnd }
    '|'                                 { Token _ TLOr }
    '^'                                 { Token _ TLXor }
    ':'                                 { Token _ TColon }
    ';'                                 { Token _ TSemicolon }
    '('                                 { Token _ TLParen }
    ')'                                 { Token _ TRParen }
    '['                                 { Token _ TLSquareB }
    ']'                                 { Token _ TRSquareB }
    '{'                                 { Token _ TLBrace }
    '}'                                 { Token _ TRBrace }
    '='                                 { Token _ TAssn }
    ','                                 { Token _ TComma }
    '.'                                 { Token _ TDot }
    '>'                                 { Token _ TGt }
    '<'                                 { Token _ TLt }
    '!'                                 { Token _ TNot }
    "<<"                                { Token _ TLeftS }
    ">>"                                { Token _ TRightS }
    "&^"                                { Token _ TLAndNot }
    "+="                                { Token _ TIncA }
    "-="                                { Token _ TDIncA }
    "*="                                { Token _ TMultA }
    "/="                                { Token _ TDivA }
    "%="                                { Token _ TModA }
    "&="                                { Token _ TLAndA }
    "|="                                { Token _ TLOrA }
    "^="                                { Token _ TLXorA }
    "&&"                                { Token _ TAnd }
    "||"                                { Token _ TOr }
    "<-"                                { Token _ TRecv }             {- unsupported -}
    "++"                                { Token _ TInc }
    "--"                                { Token _ TDInc }
    "=="                                { Token _ TEq }
    "!="                                { Token _ TNEq }
    "<="                                { Token _ TLEq }
    ">="                                { Token _ TGEq }
    ":="                                { Token _ TDeclA }
    "<<="                               { Token _ TLeftSA }
    ">>="                               { Token _ TRightSA }
    "&^="                               { Token _ TLAndNotA }
    "..."                               { Token _ TLdots }            {- unsupported -}
    break                               { Token _ TBreak }
    case                                { Token _ TCase }
    chan                                { Token _ TChan }             {- unsupported -}
    const                               { Token _ TConst }            {- unsupported -}
    continue                            { Token _ TContinue }
    default                             { Token _ TDefault }
    defer                               { Token _ TDefer }            {- unsupported -}
    else                                { Token _ TElse }
    fallthrough                         { Token _ TFallthrough }      {- unsupported -}
    for                                 { Token _ TFor }
    func                                { Token _ TFunc }
    go                                  { Token _ TGo }               {- unsupported -}
    goto                                { Token _ TGoto }             {- unsupported -}
    if                                  { Token _ TIf }
    import                              { Token _ TImport }           {- unsupported -}
    interface                           { Token _ TInterface }        {- unsupported -}
    map                                 { Token _ TMap }              {- unsupported -}
    package                             { Token _ TPackage }
    range                               { Token _ TRange }            {- unsupported -}
    return                              { Token _ TReturn }
    select                              { Token _ TSelect }           {- unsupported -}
    struct                              { Token _ TStruct }
    switch                              { Token _ TSwitch }
    type                                { Token _ TType }
    var                                 { Token _ TVar }
    print                               { Token _ TPrint }
    println                             { Token _ TPrintln }
    append                              { Token _ TAppend }
    len                                 { Token _ TLen }
    cap                                 { Token _ TCap }
    decv                                { Token _ (TDecVal _) }
    octv                                { Token _ (TOctVal _) }
    hexv                                { Token _ (THexVal _) }
    fv                                  { Token _ (TFloatVal _) }
    rv                                  { Token _ (TRuneVal _) }
    sv                                  { Token _ (TStringVal _) }
    rsv                                 { Token _ (TRStringVal _) }
    ident                               { Token _ (TIdent _) }

%%

Program     : package ident ';' TopDecls                    { Program {package=getInnerString($2), topLevels=(reverse $4)} }

TopDecls    : TopDecls TopDecl                              { $2 : $1 }
            | {- empty -}                                   { [] }

TopDecl     : Decl                                          { TopDecl $1 }
            | FuncDecl                                      { TopFuncDecl $1 }

{- Idents is in reverse order -}
Idents      : Idents ',' ident                              { (getIdent $3) : $1 }
            | ident ',' ident                               { [getIdent $3, getIdent $1] }

Type        : ident                                         { ((getOffset $1), Type $ getIdent $1) }
            | '(' Type ')'                                  { $2 }
            | '[' Expr ']' Type                             { ((getOffset $1), ArrayType $2 (snd $4)) }
            | '[' ']' Type                                  { ((getOffset $1), SliceType (snd $3)) }
            | Struct                                        { ((fst $1), StructType (snd $1)) }

Decl        : var InnerDecl                                 { VarDecl [$2] }
            | var '(' InnerDecls ')' ';'                    { VarDecl (reverse $3) }
            | type ident Type ';'                           { TypeDef [TypeDef' (getIdent $2) $3] }
            | type '(' TypeDefs ')' ';'                     { TypeDef (reverse $3) }

InnerDecl   : Idents DeclBody ';'                           { VarDecl' ((nonEmpty . reverse) $1) $2 }
            | ident DeclBody ';'                            { VarDecl' (nonEmpty [getIdent $1]) $2 }
InnerDecls  : InnerDecls InnerDecl                          { $2 : $1 }
            | {- empty -}                                   { [] }

DeclBody    : Type                                          { Left ($1, []) }
            | Type '=' EIList                               { Left ($1, $3) }
            | Type '=' Expr                                 { Left ($1, [$3]) }
            | '=' EIList                                    { Right (nonEmpty $2) }
            | '=' Expr                                      { Right (nonEmpty [$2]) }

TypeDefs    : TypeDefs ident Type ';'                       { (TypeDef' (getIdent $2) $3) : $1 }
            | ident Type ';'                                { [TypeDef' (getIdent $1) $2] }

Struct      : struct '{' FieldDecls '}'                     { ((getOffset $1), (reverse $3)) }

FieldDecls  : FieldDecls Idents Type ';'                    { (FieldDecl ((nonEmpty . reverse) $2) $3) : $1 }
            | FieldDecls ident Type ';'                     { (FieldDecl (nonEmpty [getIdent $2]) $3) : $1 }
            | {- empty -}                                   { [] }

FuncDecl    : func ident Signature BlockStmt ';'            { FuncDecl (getIdent $2) $3 $4 }

Signature   : '(' Params ')' Result                         { Signature (Parameters $2) $4 }
Params      : ParamsR                                       { reverse $1 }
            | {- empty -}                                   { [] }
ParamsR     : ParamsR ',' Idents Type                       { (ParameterDecl ((nonEmpty . reverse) $3) $4) : $1 }
            | ParamsR ',' ident Type                        { (ParameterDecl (nonEmpty [getIdent $3]) $4) : $1 }
            | Idents Type                                   { [(ParameterDecl ((nonEmpty . reverse) $1) $2)] }
            | ident Type                                    { [(ParameterDecl (nonEmpty [getIdent $1]) $2)] }
Result      : Type                                          { Just $1 }
            | {- empty -}                                   { Nothing }

Stmt        : BlockStmt ';'                                 { $1 }
            | SimpleStmt                                    { SimpleStmt $1 }
            | IfStmt ';'                                    { $1 }
            | ForStmt ';'                                   { $1 }
            | SwitchStmt ';'                                { $1 }
            | break ';'                                     { Break $ getOffset $1 }
            | continue ';'                                  { Continue $ getOffset $1 }
            | Decl                                          { Declare $1 } {- decl includes semicolon -}

            | print '(' EIList ')' ';'                      { Print $3 }
            | print '(' Expr ')' ';'                        { Print [$3] }
            | print '(' ')' ';'                             { Print [] }
            | println '(' EIList ')' ';'                    { Println $3 }
            | println '(' Expr ')' ';'                      { Println [$3] }
            | println '(' ')' ';'                           { Println [] }

            | return Expr ';'                               { Return $ Just $2 }
            | return ';'                                    { Return Nothing }

{- Stmts is in reverse order -}
Stmts       : Stmts Stmt                                    { $2 : $1 }
            | {- empty -}                                   { [] }

{- No semicolon, since we can't have semicolons in the middle of if/else statements -}
BlockStmt   : '{' Stmts '}'                                 { BlockStmt (reverse $2) }

{- Spec: https://golang.org/ref/spec#SimpleStmt -}
SimpleStNE  : {- empty -}                                   { EmptyStmt }
            | ident "++"                                    { Increment (getOffset $2) $ Var (getIdent $1) }
            | ident "--"                                    { Decrement (getOffset $2) $ Var (getIdent $1) }

            | EIList '=' EIList                             { Assign (getOffset $2) (AssignOp Nothing) (nonEmpty $1) (nonEmpty $3) }

            | Expr "+=" Expr                                { Assign (getOffset $2) (AssignOp $ Just Add) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "-=" Expr                                { Assign (getOffset $2) (AssignOp $ Just Subtract) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "|=" Expr                                { Assign (getOffset $2) (AssignOp $ Just BitOr) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "^=" Expr                                { Assign (getOffset $2) (AssignOp $ Just BitXor) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "*=" Expr                                { Assign (getOffset $2) (AssignOp $ Just Multiply) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "/=" Expr                                { Assign (getOffset $2) (AssignOp $ Just Divide) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "%=" Expr                                { Assign (getOffset $2) (AssignOp $ Just Remainder) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "<<=" Expr                               { Assign (getOffset $2) (AssignOp $ Just ShiftL) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr ">>=" Expr                               { Assign (getOffset $2) (AssignOp $ Just ShiftR) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "&=" Expr                                { Assign (getOffset $2) (AssignOp $ Just BitAnd) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr "&^=" Expr                               { Assign (getOffset $2) (AssignOp $ Just BitClear) (nonEmpty [$1]) (nonEmpty [$3]) }
            | Expr '=' Expr                                 { Assign (getOffset $2) (AssignOp Nothing) (nonEmpty [$1]) (nonEmpty [$3]) }

            | Idents ":=" EIList                            { ShortDeclare ((nonEmpty . reverse) $1) (nonEmpty $3) }
            | ident ":=" Expr                               { ShortDeclare (nonEmpty [getIdent $1]) (nonEmpty [$3]) }

{- Spec: https://golang.org/ref/spec#ExpressionStmt -}
ExprStmt    : Expr ';'    { ExprStmt $1 }

{- Spec: https://golang.org/ref/spec#SimpleStmt -}
{- Keep expression statements separate to prevent r/r conflicts -}
SimpleStmt  : SimpleStNE ';'                                { $1 }
            | ExprStmt                                      { $1 }

{- Spec: https://golang.org/ref/spec#If_statements -}
IfStmt      : if SimpleStmt Expr BlockStmt Elses            { If ($2, $3) $4 $5 }
            | if Expr BlockStmt Elses                       { If (EmptyStmt, $2) $3 $4 }
Elses       : else IfStmt                                   { $2 }
            | else BlockStmt                                { $2 }
            | {- empty -}                                   { blank }

{- Spec: https://golang.org/ref/spec#For_statements -}
ForStmt     : for BlockStmt                                 { For ForInfinite $2 }
            | for Expr BlockStmt                            { For (ForCond $2) $3 }
            | for SimpleStmt Expr ';' SimpleStNE BlockStmt  { For (ForClause $2 $3 $5) $6 }
            | for SimpleStmt Expr ';' Expr BlockStmt        { For (ForClause $2 $3 (ExprStmt $5)) $6 }

{- Spec: https://golang.org/ref/spec#Switch_statements -}
SwitchStmt  : switch SimpleStmt Expr '{' SwitchBody '}'     { Switch $2 (Just $3) (reverse $5) }
            | switch SimpleStmt '{' SwitchBody '}'          { Switch $2 Nothing (reverse $4) }
            | switch Expr '{' SwitchBody '}'                { Switch EmptyStmt (Just $2) (reverse $4) }
            | switch '{' SwitchBody '}'                     { Switch EmptyStmt Nothing (reverse $3) }

{- SwitchBody is in reverse order -}
SwitchBody  : SwitchBody case EIList ':' Stmts              { (Case (getOffset $2) (nonEmpty $3) (BlockStmt $ reverse $5)) : $1 }
            | SwitchBody case Expr ':' Stmts                { (Case (getOffset $2) (nonEmpty [$3]) (BlockStmt $ reverse $5)) : $1 }
            | SwitchBody default ':' Stmts                  { (Default (getOffset $2) $ BlockStmt (reverse $4)) : $1 }
            | {- empty -}                                   { [] }


{- Spec: https://golang.org/ref/spec#Expressions -}

Expr        : NIExpr                                        { $1 }
            | ident                                         { Var (getIdent $1) }

NIExpr      : '+' Expr %prec POS                            { Unary (getOffset $1) Pos $2 }
            | '-' Expr %prec NEG                            { Unary (getOffset $1) Neg $2 }
            | '!' Expr                                      { Unary (getOffset $1) Not $2 }
            | '^' Expr %prec COM                            { Unary (getOffset $1) BitComplement $2 }
            | Expr "||" Expr                                { Binary (getOffset $2) Or $1 $3 }
            | Expr "&&" Expr                                { Binary (getOffset $2) And $1 $3 }
            | Expr "==" Expr                                { Binary (getOffset $2) Data.EQ $1 $3 }
            | Expr "!=" Expr                                { Binary (getOffset $2) NEQ $1 $3 }
            | Expr '<' Expr                                 { Binary (getOffset $2) Data.LT $1 $3 }
            | Expr "<=" Expr                                { Binary (getOffset $2) LEQ $1 $3 }
            | Expr '>' Expr                                 { Binary (getOffset $2) Data.GT $1 $3 }
            | Expr ">=" Expr                                { Binary (getOffset $2) GEQ $1 $3 }
            | Expr '+' Expr                                 { Binary (getOffset $2) (Arithm Add) $1 $3 }
            | Expr '-' Expr                                 { Binary (getOffset $2) (Arithm Subtract) $1 $3 }
            | Expr '*' Expr                                 { Binary (getOffset $2) (Arithm Multiply) $1 $3 }
            | Expr '/' Expr                                 { Binary (getOffset $2) (Arithm Divide) $1 $3 }
            | Expr '%' Expr                                 { Binary (getOffset $2) (Arithm Remainder) $1 $3 }
            | Expr '|' Expr                                 { Binary (getOffset $2) (Arithm BitOr) $1 $3 }
            | Expr '^' Expr                                 { Binary (getOffset $2) (Arithm BitXor) $1 $3 }
            | Expr '&' Expr                                 { Binary (getOffset $2) (Arithm BitAnd) $1 $3 }
            | Expr "&^" Expr                                { Binary (getOffset $2) (Arithm BitClear) $1 $3 }
            | Expr "<<" Expr                                { Binary (getOffset $2) (Arithm ShiftL) $1 $3 }
            | Expr ">>" Expr                                { Binary (getOffset $2) (Arithm ShiftR) $1 $3 }
            | '(' Expr ')'                                  { $2 }
            | Expr '.' ident                                { Selector (getOffset $2) $1 $ getIdent $3 }
            | Expr '[' Expr ']'                             { Index (getOffset $2) $1 $3 }
            | decv                                          { Lit (IntLit (getOffset $1) Decimal $ getInnerString $1) }
            | octv                                          { Lit (IntLit (getOffset $1) Octal $ getInnerString $1) }
            | hexv                                          { Lit (IntLit (getOffset $1) Hexadecimal $ getInnerString $1) }
            | fv                                            { Lit (FloatLit (getOffset $1) $ getInnerFloat $1) }
            | rv                                            { Lit (RuneLit (getOffset $1) $ getInnerChar $1) }
            | sv                                            { Lit (StringLit (getOffset $1) Interpreted $ getInnerString $1) }
            | rsv                                           { Lit (StringLit (getOffset $1) Raw $ getInnerString $1) }
            | append '(' Expr ',' Expr ')'                  { AppendExpr (getOffset $1) $3 $5 }
            | len '(' Expr ')'                              { LenExpr (getOffset $1) $3 }
            | cap '(' Expr ')'                              { CapExpr (getOffset $1) $3 }
            | Expr '(' ')'                                  { Arguments (getOffset $2) $1 [] } -- No arguments
            | Expr '(' Expr ')'                             { Arguments (getOffset $2) $1 [$3] } -- One argument
            | Expr '(' EIList ')'                           { Arguments (getOffset $2) $1 $3 } -- >= 2 arguments

{-
  Spec: https://golang.org/ref/spec#ExpressionList
  Note: We do not allow one expression in an expression list, since it results
  in an ambiguous grammar. Instead, we split rules into combinatorial variatons
  of single expressions and expression lists / identifiers and identifier lists.
-}

{- EIList is correctly-ordered -}
EIList      : NIExprList                                    { reverse $1 }
            | Idents                                        { map Var (reverse $1) }

{- NIExprList is reversed -}
NIExprList  : NIExprList ',' Expr                           { $3 : $1 }
            | Idents ',' NIExpr                             { $3 : (map Var $1) }
            | NIExpr ',' NIExpr                             { [$3, $1] }
            | NIExpr ',' ident                              { [(Var . getIdent) $3, $1] }
            | ident ',' NIExpr                              { [$3, (Var . getIdent) $1] }

{

-- Helper functions
getOffset :: Token -> Offset
getOffset (Token (AlexPn o _ _) _) = Offset o

nonEmpty :: [a] -> NonEmpty a
nonEmpty l = NonEmpty.fromList l

getIdent :: Token -> Identifier
getIdent t@(Token _ (TIdent id)) = Identifier (getOffset t) id

getInnerString :: Token -> String
getInnerString t = case t of
  Token _ (TDecVal val) -> val
  Token _ (TOctVal val) -> val
  Token _ (THexVal val) -> val
  Token _ (THexVal val) -> val
  Token _ (TStringVal val) -> val
  Token _ (TRStringVal val) -> val
  Token _ (TIdent val) -> val

getInnerFloat :: Token -> Float
getInnerFloat (Token _ (TFloatVal val)) = val

getInnerChar :: Token -> Char
getInnerChar (Token _ (TRuneVal val)) = val

-- Main parse function
parse :: String -> Either String Program
parse s = either (Left . errODef s) Right (runAlex s $ hparse)

-- Extract posn only
ptokl t = case t of
          Token pos _ -> pos

parseError :: (Token) -> Alex a
parseError (Token (AlexPn o l c) t) =
           alexError ("Error: parsing error, unexpected " ++ (humanize t) ++ " at: ", o)
}
