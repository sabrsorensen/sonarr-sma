#! /bin/bash

config_path="/config/app/config.xml"
server_address=$(grep "<BindAddress>.*</BindAddress>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
if [[ "$server_address" = "*" ]]
then
    server_address="localhost"
fi

server_port=$(grep "<Port>.*</Port>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
api_key=$(grep "<ApiKey>.*</ApiKey>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
url_base=$(grep "<UrlBase>.*</UrlBase>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
if [[ -n $url_base ]]
then
    url_base="${url_base}/"
fi
url="${server_address}:${server_port}/${url_base}api/v3/health?apikey=${api_key}"
http_url="http://$url"

ssl_enabled=$(grep "<EnableSsl>.*</EnableSsl>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
if [[ "$ssl_enabled" = "True" ]]
then
    ssl_server_port=$(grep "<SslPort>.*</SslPort>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
    ssl_url="https://$url"
fi

http_result=$(curl --silent --show-error -f $http_url)
if [[ $http_result ]]
then
    if [[ "$ssl_enabled" = "True" ]]
    then
        ssl_result=$(curl --silent --show-error -f $ssl_url)
        if [[ $ssl_result ]]
        then
            # both http and https are healthy
            exit 0
        else
            # https unhealthy
            exit 1
        fi
    else
        # http healthy, no https
        exit 0
    fi
else
    # http unhealthy
    exit 1
fi
