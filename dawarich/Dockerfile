FROM freikin/dawarich:0.25.9

RUN apk -U add --no-cache \
    jq \
    redis

COPY ./haos-entrypoint.sh /usr/local/bin/haos-entrypoint.sh
RUN chmod +x /usr/local/bin/haos-entrypoint.sh

COPY ./environment.rb config/environments/development.rb
COPY ./assets.rb config/initializers/assets.rb
COPY ./application_controller.rb app/controllers/application_controller.rb

ENTRYPOINT [ "haos-entrypoint.sh" ]

