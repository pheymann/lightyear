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
           shouldParseEq integer "123" 123
         it "parse recursive structures" $ do
           shouldParseEq (listOf integer) "[1,2,3,98]" [1, 2, 3, 98]
           shouldParseEq (listOf' integer) "[1,2,3,99]" [1, 2, 3, 99]
         it "parse nested structures" $ do
           shouldParseEq (listOf $ listOf integer) "[[1,2],[],[3,4,5]]" [[1, 2], [], [3, 4, 5]]
           shouldParseEq (listOf' $ listOf integer) "[[1,2],[],[3,4,5,6]]" [[1, 2], [], [3, 4, 5, 6]]
         it "should commit and fail" $ do
           shouldNotParseEq (listOf integer) "foo" "At 1:1:\n\tstring \"[\"\nAt 1:1:\n\tcharacter '['\nAt 1:1:\n\ta different token"         
           shouldParseEq (listOf' integer <|> (string "[foo" *> pure List.Nil)) "[foo" []
           shouldNotParseEq (listOf integer <|> (string "[foo" *> pure List.Nil)) "[foo" "At 1:2:\n\tstring \"]\"\nAt 1:2:\n\tcharacter ']'\nAt 1:2:\n\ta different token"
