FROM haskell:9.8.2 AS build

RUN apt-get update && apt-get install --yes --no-install-recommends upx

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

# ldd returns 0 if there are linked libraries, 1 otherwise
# fail if not statically linked
RUN ! ldd gestational-calendar

RUN upx gestational-calendar

FROM scratch

COPY --from=build /app/gestational-calendar /gestational-calendar

ENV PORT=8080
EXPOSE $PORT
CMD ["/gestational-calendar"]
