module ICalendar (vCalendar, vEvent, Event) where

import           Data.Time.Calendar       (Day)
import           Data.Time.Format.ISO8601 (FormatExtension (BasicFormat),
                                           calendarFormat, formatShow)

type Event = [String]

vCalendar :: [Event] -> String
vCalendar = unlinesWithCRLF . (\events -> header ++ concat events ++ footer)
  where
    header =
      [ "BEGIN:VCALENDAR"
      , "PRODID:genetational-calendar"
      , "VERSION:2.0"
      ]
    footer = ["END:VCALENDAR"]

vEvent :: Day -> String -> Event
vEvent day summary =
  [ "BEGIN:VEVENT"
  , "DTSTART:" ++ formatShow (calendarFormat BasicFormat) day
  , "SUMMARY:" ++ summary
  , "END:VEVENT"
  ]

unlinesWithCRLF :: [String] -> String
unlinesWithCRLF = concatMap (++ "\r\n")
