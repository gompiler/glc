{module Parser ( putExit
                , AlexPosn(..))
where
import Scanner
import Data
import System.Exit
import System.IO
}

-- Name of parse function generated by Happy
%name hparse
%tokentype { Token }
%monad { P } { thenP } { returnP }
%lexer { lexer } { Token _ TEOF }
%errorhandlertype explist
%error { parseError }

%left "||"
%left "&&"
%left "==" "!=" '<' "<=" '>' ">="
%left '+' '-' '|' '^'
%left '*' '/' '%' "<<" ">>" '&' "&^"
{- TODO: IMPORTANCE RANKINGS FOR THESE -}
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
Program    : package TopDecls                       { Program {package=$1, topLevels=$2} }
TopDecls   : TopDecls TopDecl                       { $2 : $1 }
           | {- empty -}                            { [] }

TopDecl    : Decl                                   { TopDecl $1 }
           | FuncDecl                               { TopFuncDecl $1 }

Idents     : Idents ident                           { $2 : $1 }
           | {- empty -}                            { [] }

{- need errors for figuring out if a type was present and if so whether an expression was passed -}
Decl       : var InnerDecl ';'                      { $2 }
           | var '(' InnerDecls ')' ';'             { $3 }

InnerDecl  : Idents DeclBody ';'                    { VarDecl' $1 $3 }
InnerDecls : InnerDecls InnerDecl                   { $2 : $1 }
           | {- empty -}                            { [] }

{- TODO: TYPES OF RETURN... -}
DeclBody   : type                                   { (tokenTypeToASTType($1), []) }
           | type '=' ExprList                      { (tokenTypeToASTType($1), $3) }
           | '=' ExprList                           { (ExprList) }

{- TODO: OPTIONAL/COMPLEX FUNC TYPE -}
FuncDecl   : func ident '('  ')' type BlockStmt     { FuncDecl %2 TODO %7 }

Stmt       : BlockStmt ';'                          { $1 }
           | ';'                                    { EmptyStmt }
           | SimpleStmt ';'                         { $1 }
           | IfStmt ';'                             { $1 }
           | break ';'                              { Break }
           | continue ';'                           { Continue }
           | Decl ';'                               { Declare $1 }

Stmts      : Stmts Stmt                             { $2 : $1 }
           | {- empty -}                            { [] }

BlockStmt  : '{' Stmts '}'                          { $2 }

SimpleStmt : ident "++"                             { Increment $1 }
           | ident "--"                             { Decrement $1 }
           | ExprList "+=" ExprList ';'             { Assign (AssignOp $ Just Add) $1 $4 }
           | ExprList "-=" ExprList ';'             { Assign (AssignOp $ Just Subtract) $1 $4 }
           | ExprList "|=" ExprList ';'             { Assign (AssignOp $ Just BitOr) $1 $4 }
           | ExprList "^=" ExprList ';'             { Assign (AssignOp $ Just BitXor) $1 $4 }
           | ExprList "*=" ExprList ';'             { Assign (AssignOp $ Just Multiply) $1 $4 }
           | ExprList "/=" ExprList ';'             { Assign (AssignOp $ Just Divide) $1 $4 }
           | ExprList "%=" ExprList ';'             { Assign (AssignOp $ Just Remainder) $1 $4 }
           | ExprList "<<=" ExprList ';'            { Assign (AssignOp $ Just ShiftL) $1 $4 }
           | ExprList ">>=" ExprList ';'            { Assign (AssignOp $ Just ShiftR) $1 $4 }
           | ExprList "&=" ExprList ';'             { Assign (AssignOp $ Just BitAnd) $1 $4 }
           | ExprList "&^=" ExprList ';'            { Assign (AssignOp $ Just BitClear) $1 $4 }
           | ExprList '=' ExprList ';'              { Assign (AssignOp Nothing) $2 $1 $4 }
        {- | TODO: SHORT DECL -}

IfStmt     : if SimpleStmt ';' Expr BlockStmt Elses { If ($2, $3) $4 $5 }
           | if Expr BlockStmt Elses                { If (blank, $2) $3 $4 }
Elses      : else IfStmt                            { $2 }
           | else BlockStmt                         { $2 }
           | {- empty -}                            { blank }

Expr       : '+' Expr %prec POS                     { Unary Pos $2 }
           | '-' Expr %prec NEG                     { Unary Neg $2 }
           | '!' Expr                               { Unary Not $2 }
           | '^' Expr %prec COM                     { Unary BitComplement $2 }
           | Expr "||" Expr                         { Binary $1 Or $3 }
           | Expr "&&" Expr                         { Binary $1 And $3 }
           | Expr "==" Expr                         { Binary $1 EQ $3 }
           | Expr "!=" Expr                         { Binary $1 NEQ $3 }
           | Expr '<' Expr                          { Binary $1 LT $3 }
           | Expr "<=" Expr                         { Binary $1 LEQ $3 }
           | Expr '>' Expr                          { Binary $1 GT $3 }
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
           | decv                                   { Lit (IntLit Decimal $$) }
           | octv                                   { Lit (IntLit Octal $$) }
           | hexv                                   { Lit (IntLit Hexadecimal $$) }
           | fv                                     { Lit (FloatLit $$) } {- TODO: TYPES -}
           | rv                                     { Lit (RuneLit $$) } {- TODO: TYPES -}
           | sv                                     { Lit (StringLit Interpreted $$) }
           | rsv                                    { Lit (StringLit Raw $$) }
           | append '(' Expr ',' Expr ')'           { AppendExpr $3 $5 }
           | len '(' Expr ')'                       { LenExpr $3 }
           | cap '(' Expr ')'                       { CapExpr $3 }

ExprList   : ExprList ',' Expr                      { $3 : $1 }
           | Expr                                   { [$1] }

{

-- Extract posn only
ptokl t = case t of
          Token pos _ -> pos

-- parseError function for better error messages
parseError :: (Token, [String]) -> Alex a
parseError (Token (AlexPn _ l c) t, strs) =                                           -- Megaparsec error reporting here
  alexError ("Error: parsing error, unexpected " ++ (prettify t) ++ " at line " ++ show l ++ " column " ++ show c ++ ", expecting " ++ show strs)

}
