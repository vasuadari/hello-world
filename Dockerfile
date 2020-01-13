FROM ruby:2.6.4-alpine as builder

RUN apk add --update build-base gcc libstdc++ openssl

WORKDIR /app

ADD Gemfile /app/Gemfile

ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install --path ./vendor

ADD . /app

RUN bundle install --path ./vendor

FROM ruby:2.6.4-alpine

RUN apk add --update curl

WORKDIR /app

COPY --from=builder /app/ /app/

RUN bundle install --path ./vendor

EXPOSE 3000

CMD ["bundle exec", "puma", "-C /app/config/puma.rb"]
