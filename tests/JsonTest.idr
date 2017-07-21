module JsonTest

import Json

import TestUtil
import Specdris.Spec

export
specs : SpecTree
specs = describe "Json parser (data from examples)" $ do
         it "JSON 1" $ do
           shouldParseEqShow 
             jsonToplevelValue
             "[1,2,4,[5,6],null,{\"some\":[\"object\"]},false]"
             "[1, 2, 4, [5, 6], null, {\"some\": [\"object\"]}, false]"
         it "JSON 2" $ do
           shouldParseEqShow
             jsonToplevelValue
             "{\n  \"hallo\":42,\"nichts\":null}"
             "{\"hallo\": 42, \"nichts\": null}"
         it "JSON 3" $ do
           shouldParseEqShow
             jsonToplevelValue
             "{\"hello\": [{\"world\": false}, 3, \"string\", true, null]}"
             "{\"hello\": [{\"world\": false}, 3, \"string\", true, null]}"
         it "JSON 4" $ do
           shouldNotParseEq
             jsonToplevelValue
             "{{\n  \"hallo\":42,\"nichts\":null}"
             """At 1:1:
	character '['
At 1:1:
	a different token
At 1:2:
	character '}'
At 1:2:
	a different token"""
