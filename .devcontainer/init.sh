#!/usr/bin/env sh

echo "Creating .env file"

cat <<EOF > .devcontainer/.env
USERNAME=$(id -un)
USER_UID=$(id -u)
USER_GID=$(id -g)
EOF
