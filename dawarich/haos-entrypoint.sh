#!/bin/sh

echo "";
echo "██████╗  █████╗ ██╗    ██╗ █████╗ ██████╗ ██╗ ██████╗██╗  ██╗";
echo "██╔══██╗██╔══██╗██║    ██║██╔══██╗██╔══██╗██║██╔════╝██║  ██║";
echo "██║  ██║███████║██║ █╗ ██║███████║██████╔╝██║██║     ███████║";
echo "██║  ██║██╔══██║██║███╗██║██╔══██║██╔══██╗██║██║     ██╔══██║";
echo "██████╔╝██║  ██║╚███╔███╔╝██║  ██║██║  ██║██║╚██████╗██║  ██║";
echo "╚═════╝ ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝";
echo "";

set -e

export DATABASE_HOST=$(jq -r '.db_host' /data/options.json)
export DATABASE_USERNAME=$(jq -r '.db_user' /data/options.json)
export DATABASE_PASSWORD=$(jq -r '.db_pass' /data/options.json)
export DATABASE_NAME=$(jq -r '.db_name' /data/options.json)

export APPLICATION_HOSTS=$(jq -r '.hosts' /data/options.json)

export STORE_GEODATA=true

# Remove pre-existing puma/passenger server.pid
rm -f $APP_PATH/tmp/pids/server.pid

echo "🚀 Starting redis server..."
redis-server &

# Wait for the database to become available
echo "⏳ Waiting for redis to be ready..."
sleep 2
until redis-cli --raw incr ping; do
  echo "⏳ Redis is unavailable - retrying..."
  sleep 2
done
echo "✅ Redis is ready!"

# Wait for the database to become available
echo "⏳ Waiting for database "$DATABASE_NAME" to be ready on $DATABASE_USERNAME@$DATABASE_HOST..."
sleep 2
until PGPASSWORD=$DATABASE_PASSWORD psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -c '\q' 2>/dev/null; do
  >&2 echo "⏳ Postgres is unavailable - retrying..."
  sleep 2
done
echo "✅ PostgreSQL is ready!"

# Run database migrations
echo "🛠️ Running database migrations..."
bundle exec rails db:migrate

# Run data migrations
echo "🛠️ Running DATA migrations..."
bundle exec rake data:migrate

echo "🛠️ Running seeds..."
bundle exec rails db:seed

echo "🚀 Starting server..."
bundle exec rails server -b :: &

echo "🚀 Starting sidekiq..."
bundle exec sidekiq
