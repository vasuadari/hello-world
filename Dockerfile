FROM bitwalker/alpine-elixir:latest AS builder

ARG MIX_ENV=$MIX_ENV

WORKDIR /opt/release

COPY . ./

RUN mix deps.get

RUN mix release

FROM alpine:latest AS app

ARG MIX_ENV=$MIX_ENV

RUN apk --update --no-cache add openssl ncurses-libs tini

RUN adduser -h /opt/app -D app

COPY --from=builder /opt/release/_build/$MIX_ENV/rel/hello_world /opt/app

COPY entrypoint.sh /entrypoint.sh

WORKDIR /opt/app

EXPOSE 4000

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

CMD ["./bin/hello_world", "start"]
