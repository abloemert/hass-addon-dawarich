FROM freikin/dawarich:0.26.7

RUN apk -U add --no-cache \
    jq \
    redis

COPY ./haos-entrypoint.sh /usr/local/bin/haos-entrypoint.sh
RUN chmod +x /usr/local/bin/haos-entrypoint.sh

COPY ./environment.rb config/environments/development.rb

ENTRYPOINT [ "haos-entrypoint.sh" ]

