FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/endoflife-date/endoflife.date.git && \
    cd endoflife.date && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM ruby AS build

WORKDIR /endoflife.date
COPY --from=base /git/endoflife.date .
RUN bundle install && \
    bundle exec jekyll build

FROM joseluisq/static-web-server

COPY --from=build /endoflife.date/_site ./public
