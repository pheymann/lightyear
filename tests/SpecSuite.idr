module SpecSuite

import Test
import JsonTest

import Specdris.Spec

export
specSuite : IO ()
specSuite = spec $ do Test.specs
                      JsonTest.specs
