module Event
  ( events
  , eventsWeek
  , eventsMonth
  , eventExpectedDelivery
  , eventEstimatedOvulation
  ) where

import           Data.Time.Calendar (Day, addDays)

import           ICalendar          (Event, vEvent)

standardDuration :: Num a => a
standardDuration = 280

start :: Day -> Day
start expectedDelivery = addDays (-standardDuration) expectedDelivery

events :: Day -> [Event]
events =
  mconcat
    [ eventsWeek
    , eventsMonth
    , pure . eventExpectedDelivery
    , pure . eventEstimatedOvulation
    ]

eventsWeek :: Day -> [Event]
eventsWeek expectedDelivery = zipWith vEvent days $ map titleWeek [0..]
  where
    days = takeWhile (expectedDelivery >=) $ iterate (addDays 7) $ start expectedDelivery

eventsMonth :: Day -> [Event]
eventsMonth expectedDelivery = zipWith vEvent days $ map titleMonth [1..]
  where
    days = takeWhile (expectedDelivery >=) $ iterate (addDays 28) $ start expectedDelivery

eventExpectedDelivery :: Day -> Event
eventExpectedDelivery expectedDelivery = vEvent expectedDelivery "出産予定日"

eventEstimatedOvulation :: Day -> Event
eventEstimatedOvulation expectedDelivery = vEvent (addDays 14 (start expectedDelivery)) "推定排卵日"

titleWeek :: Int -> String
titleWeek n = "満" ++ show n ++ "週開始"

titleMonth :: Int -> String
titleMonth n = "妊娠" ++ show n ++ "ヶ月開始"
