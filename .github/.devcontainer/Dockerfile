FROM node:lts-slim

RUN set -eux; \
	apt update -y -qq && apt install -y -qq ruby-full build-essential \
	&& gem install bundler;

RUN npm -g install styled-components@6.1.19 @redocly/cli@1.8.2

USER node

RUN gem install --user-install github-pages webrick \
	&& ln -s $(ruby -r rubygems -e 'puts Gem.user_dir')/bin ~/.local/bin \
	&& echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

