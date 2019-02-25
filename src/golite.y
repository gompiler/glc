{module Parser ( putExit
                , AlexPosn(..)
                , runAlex
                , hparse
                , hparseId
                , hparseE)
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
%monad { P } { thenP } { returnP }
%lexer { lexer } { Token _ TEOF }
%errorhandlertype explist
%error { parseError }

-- Other partial parsers for testing
%partial hparseId IdentsR
%partial hparseE Expr

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

{- TODO: TYPEDEFS -}
{- TODO: EXPRESSION STATEMENTS -}
{- TODO: FUNCTION TYPES -}
{- TODO: FOR LOOPS -}
{- TODO: SWITCH/CASE -}
{- TODO: LABELS -}
{- TODO: TYPECASTS -}

{- WHY DOES PACKAGE USE STRING AND NOT PACKAGENAME? -}
Program    : package ident TopDecls                 { Program {package=getIdent($2), topLevels=$3} }
TopDecls   : TopDecls TopDecl                       { $2 : $1 }
           | {- empty -}                            { [] }

TopDecl    : Decl                                   { TopDecl $1 }
           | FuncDecl                               { TopFuncDecl $1 }

Idents     : IdentsR                                { reverse $1 }
IdentsR    : IdentsR ',' ident                      { (getIdent $3) : $1 } {- TODO -}
           | ident                                  { [getIdent $1] }

{- need errors for figuring out if a type was present and if so whether an expression was passed -}
{- TODO: LIST OF DECLARATIONS...? -}
Decl       : var InnerDecl ';'                      { VarDecl [$2] }
           | var '(' InnerDecls ')' ';'             { VarDecl $3 }

InnerDecl  : Idents DeclBody ';'                    { VarDecl' (nonEmpty $1) $2 }
InnerDecls : InnerDecls InnerDecl                   { $2 : $1 }
           | {- empty -}                            { [] }

{- TODO: TYPES OF RETURN... NEED OVERRIDING AND STUFF -}
DeclBody   : ident                                  { Left (Type (getIdent $1), []) }
           | ident '=' ExprList                     { Left (Type (getIdent $1), $3) }
           | '=' ExprList                           { Right (nonEmpty $2) }

{- TODO: OPTIONAL/COMPLEX FUNC TYPE -}
FuncDecl   : func ident Signature BlockStmt         { FuncDecl (getIdent $2) $3 $4 } {- TODO: PACKAGE NAME? -}

Signature  : '(' Params ')' Result                  { Signature (Parameters $2) $4 }
Params     : Params Idents ident                    { (ParameterDecl (nonEmpty $2) (Type $ getIdent $3)) : $1 }
           | {- empty -}                            { [] }
Result     : ident                                  { Just (Type $ getIdent $1) }
           | {- empty -}                            { Nothing }

Stmt       : BlockStmt ';'                          { $1 }
           | ';'                                    { SimpleStmt EmptyStmt }
           | SimpleStmt ';'                         { SimpleStmt $1 }
           | IfStmt ';'                             { $1 }
           | break ';'                              { Break }
           | continue ';'                           { Continue }
           | Decl ';'                               { Declare $1 }

Stmts      : Stmts Stmt                             { $2 : $1 }
           | {- empty -}                            { [] }

BlockStmt  : '{' Stmts '}'                          { BlockStmt $2 }

SimpleStmt : ident "++"                             { Increment $ Var (getIdent $1) } {- TODO -}
           | ident "--"                             { Decrement $ Var (getIdent $1) } {- TODO -}
           | ExprList "+=" ExprList ';'             { Assign (AssignOp $ Just Add) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "-=" ExprList ';'             { Assign (AssignOp $ Just Subtract) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "|=" ExprList ';'             { Assign (AssignOp $ Just BitOr) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "^=" ExprList ';'             { Assign (AssignOp $ Just BitXor) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "*=" ExprList ';'             { Assign (AssignOp $ Just Multiply) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "/=" ExprList ';'             { Assign (AssignOp $ Just Divide) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "%=" ExprList ';'             { Assign (AssignOp $ Just Remainder) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "<<=" ExprList ';'            { Assign (AssignOp $ Just ShiftL) (nonEmpty $1) (nonEmpty $3) }
           | ExprList ">>=" ExprList ';'            { Assign (AssignOp $ Just ShiftR) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "&=" ExprList ';'             { Assign (AssignOp $ Just BitAnd) (nonEmpty $1) (nonEmpty $3) }
           | ExprList "&^=" ExprList ';'            { Assign (AssignOp $ Just BitClear) (nonEmpty $1) (nonEmpty $3) }
           | ExprList '=' ExprList ';'              { Assign (AssignOp Nothing) (nonEmpty $1) (nonEmpty $3) }
        {- | TODO: SHORT DECL -}

IfStmt     : if SimpleStmt ';' Expr BlockStmt Elses { If ($2, $4) $5 $6 }
           | if Expr BlockStmt Elses                { If (EmptyStmt, $2) $3 $4 }
Elses      : else IfStmt                            { $2 }
           | else BlockStmt                         { $2 }
           | {- empty -}                            { blank }

Expr       : '+' Expr %prec POS                     { Unary Pos $2 }
           | '-' Expr %prec NEG                     { Unary Neg $2 }
           | '!' Expr                               { Unary Not $2 }
           | '^' Expr %prec COM                     { Unary BitComplement $2 }
           | Expr "||" Expr                         { Binary $1 Or $3 }
           | Expr "&&" Expr                         { Binary $1 And $3 }
           | Expr "==" Expr                         { Binary $1 Data.EQ $3 }
           | Expr "!=" Expr                         { Binary $1 NEQ $3 }
           | Expr '<' Expr                          { Binary $1 Data.LT $3 }
           | Expr "<=" Expr                         { Binary $1 LEQ $3 }
           | Expr '>' Expr                          { Binary $1 Data.GT $3 }
           | Expr ">=" Expr                         { Binary $1 GEQ $3 }
           | Expr '+' Expr                          { Binary $1 (Arithm Add) $3 }
           | Expr '-' Expr                          { Binary $1 (Arithm Subtract) $3 }
           | Expr '*' Expr                          { Binary $1 (Arithm Multiply) $3 }
           | Expr '/' Expr                          { Binary $1 (Arithm Divide) $3 }
           | Expr '%' Expr                          { Binary $1 (Arithm Remainder) $3 }
           | Expr '|' Expr                          { Binary $1 (Arithm BitOr) $3 }
           | Expr '^' Expr                          { Binary $1 (Arithm BitXor) $3 }
           | Expr '&' Expr                          { Binary $1 (Arithm BitAnd) $3 }
           | Expr "&^" Expr                         { Binary $1 (Arithm BitClear) $3 }
           | Expr "<<" Expr                         { Binary $1 (Arithm ShiftL) $3 }
           | Expr ">>" Expr                         { Binary $1 (Arithm ShiftR) $3 }
           | decv                                   { Lit (IntLit Decimal $ getInnerString $1) } {- TODO: TYPES/ERRORS -}
           | octv                                   { Lit (IntLit Octal $ getInnerString $1) } {- TODO: TYPES/ERRORS -}
           | hexv                                   { Lit (IntLit Hexadecimal $ getInnerString $1) } {- TODO: TYPES/ERRORS -}
           | fv                                     { Lit (FloatLit $ getInnerFloat $1) } {- TODO: TYPES/ERRORS -}
           | rv                                     { Lit (RuneLit $ getInnerChar $1) } {- TODO: TYPES/ERRORS -}
           | sv                                     { Lit (StringLit Interpreted $ getInnerString $1) }
           | rsv                                    { Lit (StringLit Raw $ getInnerString $1) }
           | append '(' Expr ',' Expr ')'           { AppendExpr $3 $5 }
           | len '(' Expr ')'                       { LenExpr $3 }
           | cap '(' Expr ')'                       { CapExpr $3 }

ExprList   : ExprList ',' Expr                      { $3 : $1 }
           | Expr                                   { [$1] }

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
