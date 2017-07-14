module TestUtil

import Lightyear
import Lightyear.Char
import Lightyear.Strings

import Specdris.Spec

%access export
%default total

shouldParse : (Show a, Eq a) => Parser a -> (raw : String) -> (expected : a) -> SpecResult
shouldParse p raw expected = case parse p raw of
                               (Left err)     => (BinaryFailure raw expected err)
                               (Right actual) => actual === expected

shouldParseShow : Show a => Parser a -> (raw : String) -> (expected : String) -> SpecResult
shouldParseShow p raw expected = case parse p raw of
                                   (Left err)     => (BinaryFailure raw expected err)
                                   (Right actual) => (show actual) === expected

shouldNotParse : Show a => Parser a -> (raw : String) -> (expected : String) -> SpecResult
shouldNotParse p raw expected = case parse p raw of
                                  (Left actual)  => actual === expected
                                  (Right err)    => (BinaryFailure err expected "should fail")
