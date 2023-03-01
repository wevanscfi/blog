# Dockerfile development version
FROM ruby:3.2.0 AS blog-dev

# Install codeclimate reporter
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /opt/cc-test-reporter
RUN chmod +x /opt/cc-test-reporter

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

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
RUN yarn install

# Copy the remaining files
COPY . .

# Start server
CMD bundle exec rails server -b 0.0.0.0

