FROM freikin/dawarich:0.26.7

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    redis \
    && rm -rf /var/lib/apt/lists/*

COPY ./haos-entrypoint.sh /usr/local/bin/haos-entrypoint.sh
RUN chmod +x /usr/local/bin/haos-entrypoint.sh

COPY ./environment.rb config/environments/development.rb

ENTRYPOINT [ "haos-entrypoint.sh" ]

