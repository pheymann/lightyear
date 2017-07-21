module SpecSuite

import ParserTest
import JsonTest
import TestLazy

import Specdris.Spec

export
specSuite : IO ()
specSuite = spec $ do ParserTest.specs
                      JsonTest.specs
                      TestLazy.specs
