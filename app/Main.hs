module Main where

import           Network.Wai.Handler.Warp (run)

import           Server                   (app)

main :: IO ()
main = run 3000 app
