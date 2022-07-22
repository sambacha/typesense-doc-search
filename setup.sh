#!/bin/env bash

set -e

echo "Lets Encrypt Init"
echo ""

while true; do
    echo "Configure and setup a TLS certificate for you using Let's Encrypt?"
    read -p "Answer: " yn
    case $yn in
        [Yy]* ) export USE_SELF_SIGNED_CERT=0; break ;;
        [Nn]* ) export USE_SELF_SIGNED_CERT=1; break ;;
        * ) echo "Please answer yes or no." ;;
    esac
done

read -p "Domain: " DOMAIN
export DOMAIN=$DOMAIN
echo "Ok we'll set up certs for https://$DOMAIN"
echo ""

cd /etc/config/

# rewrite caddyfile
export TLS_BLOCK=""
if [[ $USE_SELF_SIGNED_CERT -eq 1 ]]; then
    echo "Using a self signed certificate as requested"
    export TLS_BLOCK="tls internal"
fi

rm -f Caddyfile
envsubst > Caddyfile <<EOF
$DOMAIN, :80, :443 {
$TLS_BLOCK
reverse_proxy http://web:5005
}
EOF

# update apt cache
echo "Grabbing latest apt caches"
apt update

echo "Grabbing dependencies"
apt install -y jq

# rewrite config.json
echo "Setting up config.json ..."
echo "$( jq --arg domain "${DOMAIN}" '.host = $domain | .environment = "production"' config.json  )" > config.json
echo "config.json ready"
echo ""
echo ""

echo "Restarting services"

# Drop Docker
docker-compose down

# Start Docker
docker-compose up -d


echo "Completed.. exiting..."
