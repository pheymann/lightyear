module SpecSuite

import ParserTest
import JsonTest

import Specdris.Spec

export
specSuite : IO ()
specSuite = spec $ do ParserTest.specs
                      JsonTest.specs
