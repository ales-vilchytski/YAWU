FROM jruby:9.1.6-jre-alpine

RUN apk update && apk add file

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN chmod +x docker/start.sh

ENV RAILS_ENV=production
RUN bundle exec rake db:setup && bundle exec rake db:migrate
RUN bundle exec rake assets:precompile RAILS_ENV=production && \
    bundle exec rake assets:non_digested_ace RAILS_ENV=production

EXPOSE 3000/tcp

CMD ["./docker/start.sh"]
