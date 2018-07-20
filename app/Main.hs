module Main where

import Data.Time.Calendar

import ICalendar

main :: IO ()
main = do
  let test = vCalendar $ [vEvent (fromGregorian 2018 9 8) "出産予定日"]
  writeFile "test.ics" test
