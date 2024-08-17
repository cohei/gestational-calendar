FROM haskell:9.8.2 AS build

RUN cabal update

WORKDIR /app

ENV LANG=C.UTF-8
COPY cabal.project gestational-calendar.cabal ./
RUN cabal build --only-dependencies

COPY Setup.hs README.md LICENSE ./
COPY app/ app/
COPY src/ src/
COPY test/ test/

# Getting your Haskell executable statically linked without Nix · Hasufell's blog
# https://hasufell.github.io/posts/2024-04-21-static-linking.html
RUN cabal build --enable-executable-static exe:gestational-calendar
RUN cp $(cabal list-bin exe:gestational-calendar) ./

RUN ldd gestational-calendar || true
RUN du -h gestational-calendar

FROM scratch

COPY --from=build /app/gestational-calendar /gestational-calendar

ENV PORT=8080
EXPOSE $PORT
CMD ["/gestational-calendar"]
