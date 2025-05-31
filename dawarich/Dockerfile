FROM freikin/dawarich:0.26.7

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    redis \
    && rm -rf /var/lib/apt/lists/*

COPY ./redis.conf /etc/redis.conf

COPY ./haos-entrypoint.sh /usr/local/bin/haos-entrypoint.sh
RUN chmod +x /usr/local/bin/haos-entrypoint.sh

COPY ./environment.rb config/environments/development.rb
COPY ./assets.rb config/initializers/assets.rb
COPY ./application_controller.rb app/controllers/application_controller.rb

ENTRYPOINT [ "haos-entrypoint.sh" ]

