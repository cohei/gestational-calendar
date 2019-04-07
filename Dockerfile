FROM haskell:8.6.3 AS build

# STATIC COMPILATION WITH STACK.
# https://www.fpcomplete.com/blog/2016/10/static-compilation-with-stack

WORKDIR /usr/lib/gcc/x86_64-linux-gnu/6/
RUN cp crtbeginT.o crtbeginT.o.orig
RUN cp crtbeginS.o crtbeginT.o

WORKDIR /app

COPY stack.yaml ./
RUN stack setup

COPY package.yaml ./
RUN stack build --only-dependencies

COPY Setup.hs ./
COPY app/ app/
COPY src/ src/
RUN stack install --ghc-options '-optl-static -fPIC'

RUN ldd /root/.local/bin/gestational-calendar || true
RUN du -hs /root/.local/bin/gestational-calendar

FROM scratch

COPY --from=build /root/.local/bin/gestational-calendar /gestational-calendar

ENV PORT 8080
EXPOSE $PORT
CMD ["/gestational-calendar"]
