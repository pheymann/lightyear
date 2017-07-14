module ParserTest

import Data.Vect
import Data.Fin

import Lightyear
import Lightyear.Char
import Lightyear.Strings

import TestUtil
import Specdris.Spec

listOf : Parser a -> Parser (List a)
listOf p = string "[" *!> (p `sepBy` string ",") <* string "]"

listOf' : Parser a -> Parser (List a)
listOf' p = brackets (commaSep p)

export
specs : SpecTree
specs = describe "Parser" $ do
         it "parse scalar values" $ do
           shouldParse integer "123" 123
         it "parse recursive structures" $ do
           shouldParse (listOf integer) "[1,2,3,98]" [1, 2, 3, 98]
           shouldParse (listOf' integer) "[1,2,3,99]" [1, 2, 3, 99]
         it "parse nested structures" $ do
           shouldParse (listOf $ listOf integer) "[[1,2],[],[3,4,5]]" [[1, 2], [], [3, 4, 5]]
           shouldParse (listOf' $ listOf integer) "[[1,2],[],[3,4,5,6]]" [[1, 2], [], [3, 4, 5, 6]]
         it "should commit and fail" $ do
           shouldParse (listOf' integer <|> (string "[foo" *> pure List.Nil)) "[foo" []
           shouldNotParse (listOf integer <|> (string "[foo" *> pure List.Nil)) "[foo" """at 1:2 expected:
  string "]"
at 1:2 expected:
  character ']'
at 1:2 expected:
  a different token
"""
