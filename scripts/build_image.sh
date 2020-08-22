#! /usr/bin/env bash

docker build --build-arg MIX_ENV=$MIX_ENV -t vasuadari/hello-world:elixir .

docker tag vasuadari/hello-world:elixir vasuadari/hello-world:elixir

echo "Run following commands to push image to docker hub:"

echo "docker login"

echo "docker push vasuadari/hello-world:elixir"
