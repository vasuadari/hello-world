FROM bitwalker/alpine-elixir:latest AS builder

RUN elixir -v

ARG MIX_ENV=$MIX_ENV

WORKDIR /opt/release

COPY . ./

RUN mix deps.get

RUN mix release --quiet

RUN adduser -h /opt/app -D app

RUN chown -R app: _build/

FROM alpine:latest AS app

ARG MIX_ENV=$MIX_ENV

RUN apk --update --no-cache add openssl ncurses-libs tini

RUN adduser -h /opt/app -D app

USER app

WORKDIR /opt/app

COPY --from=builder /opt/release/_build/$MIX_ENV/rel/hello_world ./

COPY entrypoint.sh /entrypoint.sh

EXPOSE 4000

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

CMD ["./bin/hello_world", "start"]
