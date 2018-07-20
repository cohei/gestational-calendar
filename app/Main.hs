module Main where

import Data.Time.Calendar
import System.Environment (getArgs)

import Event (events)
import ICalendar (vCalendar)

main :: IO ()
main = do
  y:m:d:_ <- getArgs
  let test = vCalendar $ events $ fromGregorian (read y) (read m) (read d)
  writeFile "test.ics" test
