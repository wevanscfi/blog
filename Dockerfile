# Dockerfile development version
FROM ruby:3.2.1 AS blog-dev

# Install yarn PPA
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Insall nodjs PPA
RUN curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key -o /root/nodejs-pubkey.gpg && apt-key add /root/nodejs-pubkey.gpg
ENV NODE_VERSION=node_18.x
ENV DISTRO=bullseye
RUN echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/$NODE_VERSION $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && apt-get install -y --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb nodejs yarn


# Default directory
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

# Install gems
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile.lock ./
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install 

# Install npm packages
COPY package.json yarn.lock ./
RUN yarn install --production=false

# Copy the remaining files
COPY . .

# Start server
CMD bundle exec rails server -b 0.0.0.0

