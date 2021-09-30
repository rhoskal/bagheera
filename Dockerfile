ARG ALPINE_VERSION=3.14

FROM elixir:1.11-alpine AS builder

ARG APP_NAME=bagheera
ARG APP_VSN=0.1.0
ARG MIX_ENV=prod
ARG DATABASE_URL
ARG SECRET_KEY_BASE

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

WORKDIR /opt/builder

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache git build-base && \
    mix local.rebar --force && \
    mix local.hex --if-missing --force
    
COPY . .

RUN mix do \
    deps.get --only prod, \
    deps.compile --force, \
    release

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME=bagheera

RUN apk update && \
    apk add --no-cache bash openssl-dev

WORKDIR /opt/${APP_NAME}

COPY --from=builder /opt/builder/_build/prod/rel/${APP_NAME} .

CMD trap "exit" INT; "bin/`basename $PWD`" start
