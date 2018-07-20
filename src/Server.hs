{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE TypeOperators         #-}
module Server (app) where

import           Data.Proxy              (Proxy (Proxy))
import           Data.Text.Lazy          (Text, pack)
import           Data.Text.Lazy.Encoding (encodeUtf8)
import           Data.Time.Calendar      (Day)
import           Network.HTTP.Media      ((//))
import           Network.Wai             (Application)
import           Servant                 ((:>), Accept (contentType), Capture,
                                          Get, Handler, MimeRender (mimeRender),
                                          Server, serve)

import           Event                   (events)
import           ICalendar               (vCalendar)

app :: Application
app = serve api server

type API = Capture "expectedDelivery" Day :> Get '[Calendar] Text

api :: Proxy API
api = Proxy

server :: Server API
server = calendar

calendar :: Day -> Handler Text
calendar = pure . pack . vCalendar . events

data Calendar

instance Accept Calendar where
  contentType _ = "text" // "calendar"

instance MimeRender Calendar Text where
  mimeRender _ = encodeUtf8
