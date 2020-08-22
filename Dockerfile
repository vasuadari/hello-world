FROM bitwalker/alpine-elixir:latest AS builder

ARG MIX_ENV=$MIX_ENV

WORKDIR /opt/release

COPY . ./

RUN mix deps.get

RUN mix release

FROM alpine:latest AS app

ARG MIX_ENV=$MIX_ENV

RUN apk --update add openssl ncurses-libs

RUN adduser -h /opt/app -D app

WORKDIR /opt/app

COPY --from=builder /opt/release/_build/$MIX_ENV/rel/hello_world ./

RUN chown -R app: /opt/app

EXPOSE 4000

CMD ["./bin/hello_world", "start"]
