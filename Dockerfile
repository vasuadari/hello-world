# Build Stage
FROM bitwalker/alpine-elixir:latest AS build

RUN elixir -v

# Accept MIX_ENV as build arg
ARG MIX_ENV=$MIX_ENV

# Set current working directory for next steps
WORKDIR /opt/release

# Copy all the app files
COPY . ./

# Run dependencies
RUN mix deps.get

# Create a release with quiet to skip writing progress
RUN mix release --quiet

# Create a non-root user
RUN adduser -h /opt/app -D app

# Transfer ownership to app user
RUN chown -R app: _build/

# Final Stage
FROM alpine:latest AS app

# Accept MIX_ENV as build arg
ARG MIX_ENV=$MIX_ENV

# Install system dependencies required for your app at runtime
RUN apk --update --no-cache add openssl ncurses-libs tini

# Create a non-root user
RUN adduser -h /opt/app -D app

# Switch to non-root user
USER app

# Set current working directory to app dir
WORKDIR /opt/app

# Copy release dir from build stage
COPY --from=build /opt/release/_build/$MIX_ENV/rel/hello_world ./

COPY entrypoint.sh /entrypoint.sh

EXPOSE 4000

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

# Start your app
CMD ["./bin/hello_world", "start"]
