module TestLazy

import Lightyear
import Lightyear.Char
import Lightyear.Strings
import Lightyear.Testing

import TestUtil
import Specdris.Spec

%default partial

data Ty = ATOM | EXPR

data SExpr : Ty -> Type where
  Atom : String -> SExpr ATOM
  AtomExpr : SExpr ATOM -> SExpr EXPR
  Expr : SExpr tyA -> SExpr tyB -> SExpr EXPR

Show (SExpr ty) where
  show (Atom a) = unwords ["Atom", a]
  show (Expr a b) = unwords ["Expr", show a, show b]

atom : Parser $ SExpr ATOM
atom = do
  cs <- some $ satisfy isAlphaNum
  pure $ Atom (pack cs)
 <?> "Atom"

expr : Parser $ SExpr EXPR
expr = do
  a <- atom
  pure $ AtomExpr a
 <|>| do
   token "("
   exprA <- expr
   spaces
   exprB <- expr
   token ")"
   pure $ Expr exprA exprB
 <?> "EXPR"

complex1 : String
complex1 = 
  """(a
  (b
    (c
      (d
        (e
          f
            (g
              (h
                (i
                  (j
                    (k
                      (l
                        (m
                          (n (o (p (q (r (s (t (u (v (w (x (y (z NIL))))))))))))))))))))))))))
"""

complex2 : String
complex2 =
  """(a
  (b
    (c
      (d
        (e
          f
            (g
              (h
                (i
                  (j
                    (k
                      (l
                        (m
                          (n (o (p (q (r (s (t (u (v (w (x (y (z NIL))))))))))))))))))))))))))"""

complex2Error : String
complex2Error =
  """At 1:1:
	EXPR
At 1:1:
	Atom
At 1:1:
	a different token
At 2:3:
	EXPR
At 2:3:
	Atom
At 2:3:
	a different token
At 3:5:
	EXPR
At 3:5:
	Atom
At 3:5:
	a different token
At 4:7:
	EXPR
At 4:7:
	Atom
At 4:7:
	a different token
At 5:9:
	EXPR
At 5:9:
	Atom
At 5:9:
	a different token
At 6:12:
	token ")"
At 6:12:
	string ")"
At 6:12:
	character ')'
At 6:12:
	a different token"""

export
specs : SpecTree
specs = describe "Lazy evaluation" $ do
          it "parse atomic expressions" $ do
            shouldParse atom "Test"
            shouldParse atom "1"
          it "parse simple expressions" $ do
            shouldParse expr "Test"
            shouldParse expr "(id x)"
          it "parse complexe expressions" $ do
            shouldParse expr "(add (1 2))"
            shouldParse expr "(a (b (c (d (e (f (g (h (i (j (k (l (m (n (o (p (q (r (s (t (u (v (w (x (y (z NIL))))))))))))))))))))))))))"         
            shouldNotParse expr complex1 
            shouldNotParseEq expr complex2 complex2Error
