FROM node:lts-slim

RUN set -eux; \
	apt update -y -qq && apt install -y -qq ruby-full build-essential \
	&& gem install bundler;
