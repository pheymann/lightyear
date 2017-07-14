module JsonTest

import Json

import TestUtil
import Specdris.Spec

export
specs : SpecTree
specs = describe "Json parser (data from examples)" $ do
         it "JSON 1" $ do
           shouldParseShow 
             jsonToplevelValue
             "[1,2,4,[5,6],null,{\"some\":[\"object\"]},false]"
             "[1, 2, 4, [5, 6], null, {\"some\": [\"object\"]}, false]"
         it "JSON 2" $ do
           shouldParseShow
             jsonToplevelValue
             "{\n  \"hallo\":42,\"nichts\":null}"
             "{\"hallo\": 42, \"nichts\": null}"
         it "JSON 3" $ do
           shouldParseShow
             jsonToplevelValue
             "{\"hello\": [{\"world\": false}, 3, \"string\", true, null]}"
             "{\"hello\": [{\"world\": false}, 3, \"string\", true, null]}"
         it "JSON 4" $ do
           shouldNotParse
             jsonToplevelValue
             "{{\n  \"hallo\":42,\"nichts\":null}"
             """at 1:1 expected:
  character '['
at 1:1 expected:
  a different token
at 1:2 expected:
  character '}'
at 1:2 expected:
  a different token
"""
