module SessionTypesSpec (spec) where

import Test.QuickCheck
import Test.Hspec
import SessionTypes
import Data.Time

-- TODO: extend the ZonedTime Arbitrary instance to have random time too
instance Arbitrary ZonedTime where
  arbitrary = do
    y <- choose (1, 9999)
    m <- choose (1, 12)
    d <- choose (1, gregorianMonthLength y m)
    return $ ZonedTime (LocalTime (fromGregorian y m d) midnight) utc

instance Arbitrary Weight where
  arbitrary = oneof
    [ return BodyWeight
    , TrainingWeight <$> arbitrary
    ]

instance Arbitrary TrainingSet where
  arbitrary = TrainingSet <$> arbitrary <*> arbitrary

instance Arbitrary Session where
  arbitrary = Session <$> arbitrary <*> arbitrary <*> arbitrary

-- To generate an arbitrary Bob; generate (arbitrary :: Gen Bob)

-- There should be a xxSpec.hs file for each src module. We'll need these instances of Arbitrary
-- in all the other tests. Does it suffice to import this module?

-- Now we need a test. SessionTypes only contains a single function, so let's test that

prop :: (Session, TrainingSet) -> Bool
prop (ses, ts) = (length $ sets (addSet ses ts)) == (length $ sets ses) + 1


spec :: Spec
spec = do
  describe "SessionTypes" $ do
    it "Adds a set" $ property $ prop
