{module Parser ( putExit
                , AlexPosn(..)
                , runAlex
                , pId
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
                , hparse)
where
import Scanner
import Data
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
%errorhandlertype explist
%error { parseError }

-- Other partial parsers for testing
%partial pId Idents
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
%partial pEl ExprList
%partial pE Expr

{- Spec: https://golang.org/ref/spec#Operator_precedence -}
%nonassoc ',' {- Lowest precedence, for arrays and expression lists. TODO: DO WE NEED THIS? -}
%left "||"
%left "&&"
%left "==" "!=" '<' "<=" '>' ">="
%left '+' '-' '|' '^'
%left '*' '/' '%' "<<" ">>" '&' "&^"
%nonassoc '!' POS NEG COM {- TODO: SHOULD THIS BE ASSOCIATIVE? -}

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
    "<-"                                { Token _ TRecv }
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
    "..."                               { Token _ TLdots }
    break                               { Token _ TBreak }
    case                                { Token _ TCase }
    chan                                { Token _ TChan }
    const                               { Token _ TConst }
    continue                            { Token _ TContinue }
    default                             { Token _ TDefault }
    defer                               { Token _ TDefer }
    else                                { Token _ TElse }
    fallthrough                         { Token _ TFallthrough }
    for                                 { Token _ TFor }
    func                                { Token _ TFunc }
    go                                  { Token _ TGo }
    goto                                { Token _ TGoto }
    if                                  { Token _ TIf }
    import                              { Token _ TImport }
    interface                           { Token _ TInterface }
    map                                 { Token _ TMap }
    package                             { Token _ TPackage }
    range                               { Token _ TRange }
    return                              { Token _ TReturn }
    select                              { Token _ TSelect }
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

{- TODO: EXPRESSION STATEMENTS -}
{- TODO: FUNCTION TYPES -}
{- TODO: LABELS -}
{- TODO: TYPECASTS -}

{- WHY DOES PACKAGE USE STRING AND NOT PACKAGENAME? -}
Program     : package ident TopDecls                  { Program {package=getIdent($2), topLevels=$3} }

TopDecls    : TopDeclsR                               { reverse $1 }
TopDeclsR   : TopDeclsR TopDecl                       { $2 : $1 }
            | {- empty -}                             { [] }

TopDecl     : Decl                                    { TopDecl $1 }
            | FuncDecl                                { TopFuncDecl $1 }

Idents      : IdentsR                                 { (nonEmpty . reverse) $1 }
IdentsR     : IdentsR ',' ident                       { (getIdent $3) : $1 } {- TODO -}
            | ident                                   { [getIdent $1] }

{- need errors for figuring out if a type was present and if so whether an expression was passed -}
{- TODO: LIST OF DECLARATIONS...? -}
Decl        : var InnerDecl ';'                       { VarDecl [$2] }
            | var '(' InnerDecls ')' ';'              { VarDecl $3 }
            | type ident ident ';'                    { TypeDef [TypeDef' (getIdent $2) (Type $ getIdent $3)] }
            | type ident Struct ';'                   { TypeDef [TypeDef' (getIdent $2) (StructType $3)] }
            | type '(' TypeDefs ')' ';'               { TypeDef $3 }

InnerDecl   : Idents DeclBody ';'                     { VarDecl' $1 $2 }
InnerDecls  : InnerDeclsR                             { reverse $1 }
InnerDeclsR : InnerDeclsR InnerDecl                   { $2 : $1 }
            | {- empty -}                             { [] }

{- TODO: TYPES OF RETURN... NEED OVERRIDING AND STUFF -}
DeclBody    : ident                                   { Left (Type (getIdent $1), []) }
            | ident '=' ExprList                      { Left (Type (getIdent $1), $3) } {- TODO: NON EMPTY? -}
            | '=' ExprList                            { Right (nonEmpty $2) }

TypeDefs    : TypeDefsR                               { reverse $1 }
TypeDefsR   : TypeDefsR ident ident ';'               { (TypeDef' (getIdent $2) (Type $ getIdent $3)) : $1 }
            | TypeDefsR ident Struct ';'              { (TypeDef' (getIdent $2) (StructType $3)) : $1}
            | {- empty -}                             { [] }

Struct      : struct '{' FieldDecls '}'               { $3 }

FieldDecls  : FieldDeclsR                             { reverse $1 }
FieldDeclsR : FieldDeclsR Idents ident ';'            { (FieldDecl $2 (Type (getIdent $3))) : $1 }
            | FieldDeclsR Idents Struct ';'           { (FieldDecl $2 (StructType $3)) : $1 }
            | {- empty -}                             { [] }

{- TODO: OPTIONAL/COMPLEX FUNC TYPE -}
FuncDecl    : func ident Signature BlockStmt          { FuncDecl (getIdent $2) $3 $4 } {- TODO: PACKAGE NAME? -}

Signature   : '(' Params ')' Result                   { Signature (Parameters $2) $4 }
Params      : ParamsR                                 { reverse $1 }
ParamsR     : ParamsR Idents ident                    { (ParameterDecl $2 (Type $ getIdent $3)) : $1 }
            | {- empty -}                             { [] }
Result      : ident                                   { Just (Type $ getIdent $1) }
            | {- empty -}                             { Nothing }

Stmt        : BlockStmt ';'                           { $1 }
            | SimpleStmt                              { SimpleStmt $1 }
            | IfStmt ';'                              { $1 }
            | ForStmt ';'                             { $1 }
            | SwitchStmt ';'                          { $1 }
            | break ';'                               { Break }
            | continue ';'                            { Continue }
         {- | fallthrough ';'                         {  } TODO -}
            | Decl ';'                                { Declare $1 }
            | print '(' ExprList ')' ';'              { Print $3 }
            | println '(' ExprList ')' ';'            { Println $3 }
            | return Expr ';'                         { Return $ Just $2 }
            | return ';'                              { Return Nothing }

Stmts       : StmtsR                                  { reverse $1 }
StmtsR      : StmtsR Stmt                             { $2 : $1 }
            | {- empty -}                             { [] }

{- No semicolon, since we can't have semicolons in the middle of if/else statements -}
BlockStmt   : '{' Stmts '}'                           { BlockStmt $2 }

SimpleStmt  : ';'                                     { EmptyStmt }
            | ident "++" ';'                          { Increment $ Var (getIdent $1) } {- TODO -}
            | ident "--" ';'                          { Decrement $ Var (getIdent $1) } {- TODO -}
            | ExprList "+=" ExprList ';'              { Assign (AssignOp $ Just Add) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "-=" ExprList ';'              { Assign (AssignOp $ Just Subtract) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "|=" ExprList ';'              { Assign (AssignOp $ Just BitOr) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "^=" ExprList ';'              { Assign (AssignOp $ Just BitXor) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "*=" ExprList ';'              { Assign (AssignOp $ Just Multiply) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "/=" ExprList ';'              { Assign (AssignOp $ Just Divide) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "%=" ExprList ';'              { Assign (AssignOp $ Just Remainder) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "<<=" ExprList ';'             { Assign (AssignOp $ Just ShiftL) (nonEmpty $1) (nonEmpty $3) }
            | ExprList ">>=" ExprList ';'             { Assign (AssignOp $ Just ShiftR) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "&=" ExprList ';'              { Assign (AssignOp $ Just BitAnd) (nonEmpty $1) (nonEmpty $3) }
            | ExprList "&^=" ExprList ';'             { Assign (AssignOp $ Just BitClear) (nonEmpty $1) (nonEmpty $3) }
            | ExprList '=' ExprList ';'               { Assign (AssignOp Nothing) (nonEmpty $1) (nonEmpty $3) }
            | Idents ":=" ExprList ';'                { ShortDeclare $1 (nonEmpty $3) }

IfStmt      : if SimpleStmt Expr BlockStmt Elses      { If ($2, $3) $4 $5 }
            | if Expr BlockStmt Elses                 { If (EmptyStmt, $2) $3 $4 }
Elses       : else IfStmt                             { $2 }
            | else BlockStmt                          { $2 }
            | {- empty -}                             { blank }

ForStmt     : for BlockStmt                           { For ForInfinite $2 }
            | for Expr BlockStmt                      { For (ForCond $2) $3 }
            | for SimpleStmt Expr ';' SimpleStmt BlockStmt { For (ForClause $2 $3 $5) $6 } {- TODO: ALIGNMENT -}

SwitchStmt  : switch SimpleStmt Expr '{' SwitchBody '}' { Switch $2 (Just $3) $5 } {- TODO: NEED EXPR / SIMPLE STMT, ALIGNMENT -}
            | switch SimpleStmt '{' SwitchBody '}'    { Switch $2 Nothing $4 }
            | switch Expr '{' SwitchBody '}'          { Switch EmptyStmt (Just $2) $4 }
            | switch '{' SwitchBody '}'               { Switch EmptyStmt Nothing $3 }

SwitchBody  : SwitchBodyR                             { reverse $1 }
SwitchBodyR : SwitchBodyR case ExprList ':' Stmts     { (Case (nonEmpty $3) (BlockStmt $5)) : $1 }
            | SwitchBodyR default Stmts               { (Default $ BlockStmt $3) : $1 }
            | {- empty -}                             { [] }

Expr        : '+' Expr %prec POS                      { Unary Pos $2 }
            | '-' Expr %prec NEG                      { Unary Neg $2 }
            | '!' Expr                                { Unary Not $2 }
            | '^' Expr %prec COM                      { Unary BitComplement $2 }
            | Expr "||" Expr                          { Binary $1 Or $3 }
            | Expr "&&" Expr                          { Binary $1 And $3 }
            | Expr "==" Expr                          { Binary $1 Data.EQ $3 }
            | Expr "!=" Expr                          { Binary $1 NEQ $3 }
            | Expr '<' Expr                           { Binary $1 Data.LT $3 }
            | Expr "<=" Expr                          { Binary $1 LEQ $3 }
            | Expr '>' Expr                           { Binary $1 Data.GT $3 }
            | Expr ">=" Expr                          { Binary $1 GEQ $3 }
            | Expr '+' Expr                           { Binary $1 (Arithm Add) $3 }
            | Expr '-' Expr                           { Binary $1 (Arithm Subtract) $3 }
            | Expr '*' Expr                           { Binary $1 (Arithm Multiply) $3 }
            | Expr '/' Expr                           { Binary $1 (Arithm Divide) $3 }
            | Expr '%' Expr                           { Binary $1 (Arithm Remainder) $3 }
            | Expr '|' Expr                           { Binary $1 (Arithm BitOr) $3 }
            | Expr '^' Expr                           { Binary $1 (Arithm BitXor) $3 }
            | Expr '&' Expr                           { Binary $1 (Arithm BitAnd) $3 }
            | Expr "&^" Expr                          { Binary $1 (Arithm BitClear) $3 }
            | Expr "<<" Expr                          { Binary $1 (Arithm ShiftL) $3 }
            | Expr ">>" Expr                          { Binary $1 (Arithm ShiftR) $3 }
            | decv                                    { Lit (IntLit Decimal $ getInnerString $1) }
            | octv                                    { Lit (IntLit Octal $ getInnerString $1) }
            | hexv                                    { Lit (IntLit Hexadecimal $ getInnerString $1) }
            | fv                                      { Lit (FloatLit $ getInnerFloat $1) }
            | rv                                      { Lit (RuneLit $ getInnerChar $1) }
            | sv                                      { Lit (StringLit Interpreted $ getInnerString $1) }
            | rsv                                     { Lit (StringLit Raw $ getInnerString $1) }
            | append '(' Expr ',' Expr ')'            { AppendExpr $3 $5 }
            | len '(' Expr ')'                        { LenExpr $3 }
            | cap '(' Expr ')'                        { CapExpr $3 }

ExprList    : ExprListR                               { reverse $1 }
ExprListR   : ExprListR ',' Expr                      { $3 : $1 }
            | Expr                                    { [$1] }

{

-- Helper functions

nonEmpty :: [a] -> NonEmpty a
nonEmpty l = NonEmpty.fromList l

getIdent :: Token -> Identifier
getIdent (Token _ (TIdent id)) = id

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
parse s = runAlex s $ hparse

-- Extract posn only
ptokl t = case t of
          Token pos _ -> pos

-- parseError function for better error messages
parseError :: (Token, [String]) -> Alex a
parseError (Token (AlexPn _ l c) t, strs) =                                           -- Megaparsec error reporting here
  alexError ("Error: parsing error, unexpected " ++ (prettify t) ++ " at line " ++ show l ++ " column " ++ show c ++ ", expecting " ++ show strs)

}
