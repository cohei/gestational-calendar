FROM haskell:9.4.4 AS build

RUN cabal update

WORKDIR /app

ENV LANG C.UTF-8
COPY cabal.project gestational-calendar.cabal ./
RUN cabal build --only-dependencies

COPY Setup.hs README.md LICENSE ./
COPY app/ app/
COPY src/ src/
COPY test/ test/
RUN cabal install exe:gestational-calendar --flags=static

RUN ldd /root/.cabal/bin/gestational-calendar || true
RUN du -h $(readlink -f /root/.cabal/bin/gestational-calendar)

FROM scratch

COPY --from=build /root/.cabal/bin/gestational-calendar /gestational-calendar

ENV PORT 8080
EXPOSE $PORT
CMD ["/gestational-calendar"]
