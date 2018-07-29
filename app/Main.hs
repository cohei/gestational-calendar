module Main where

import           Network.Wai.Handler.Warp (run)
import           System.Environment       (getEnv)

import           Server                   (app)

main :: IO ()
main = do
  port <- read <$> getEnv "PORT"
  run port app
