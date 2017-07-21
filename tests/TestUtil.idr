module TestUtil

import Lightyear
import Lightyear.Char
import Lightyear.Strings

import Specdris.Spec

%access export
%default total

shouldParse : (Show a) => Parser a -> (raw : String) -> SpecResult
shouldParse p raw = case parse p raw of
                      (Left err) => (UnaryFailure raw err)
                      (Right _)  => Success

shouldNotParse : (Show a) => Parser a -> (raw : String) -> SpecResult
shouldNotParse p raw = case parse p raw of
                         (Left _)       => Success
                         (Right actual) => (UnaryFailure raw "should fail")

shouldParseEq : (Show a, Eq a) => Parser a -> (raw : String) -> (expected : a) -> SpecResult
shouldParseEq p raw expected = case parse p raw of
                                 (Left err)     => (BinaryFailure raw expected err)
                                 (Right actual) => actual === expected

shouldParseEqShow : Show a => Parser a -> (raw : String) -> (expected : String) -> SpecResult
shouldParseEqShow p raw expected = case parse p raw of
                                     (Left err)     => (BinaryFailure raw expected err)
                                     (Right actual) => (show actual) === expected

shouldNotParseEq : Show a => Parser a -> (raw : String) -> (expected : String) -> SpecResult
shouldNotParseEq p raw expected = case parse p raw of
                                    (Left actual)  => actual === expected
                                    (Right err)    => (BinaryFailure err expected "should fail")
