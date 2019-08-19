#!/usr/bin/env bash

set -e

readonly CURRENT_DIRECTORY=$(pwd)
readonly SCRIPT_DIRECTORY=$(dirname $(realpath $0))

# PROMPT COLOURS
readonly RESET='\033[0;0m'
readonly BLACK='\033[0;30m'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'

function ask_value() {
    local message=$1
    local default_value=$2
    local value
    local default_value_message=''

    if [[ ! -z ${default_value} ]]; then
        default_value_message=" (default: ${YELLOW}${default_value}${CYAN})"
    fi

    echo -en "${CYAN}${message}${default_value_message}:${RESET} " > /dev/tty
    read value

    if [[ -z ${value} ]]; then
        if [[ -z ${default_value} ]]; then
            value=$(ask_value "${message}")
        else
            value="${default_value}"
        fi
    fi

    echo "${value}"
}

http_port=$(ask_value "Define the HTTP PORT" 80)

https_port=$(ask_value "Define the HTTPS PORT" 443)

echo -e "${YELLOW}List of Nginx version https://hub.docker.com/r/philippev/docker-proxy-nginx/tags${RESET}"
nginx_version=$(ask_value "Define the version of Nginx proxy" latest)

proxy_provider=$(ask_value "Choose proxy configurator provider (php|go)" php)

if [[ "${proxy_provider}" != "php" ]] && [[ "${proxy_provider}" != "go" ]]; then
    echo "${RED}The proxy configurator must be php or go.${RESET}"
    exit 1
fi

echo -e "${YELLOW}List of ${proxy_provider} version https://hub.docker.com/r/philippev/docker-proxy-${proxy_provider}/tags${RESET}"
proxy_provider_version=$(ask_value "Define the version of proxy configurator ${proxy_provider}" latest)

echo "COMPOSE_PROJECT_NAME=docker-proxy" > ${SCRIPT_DIRECTORY}/.env
echo "HTTP_PORT=${http_port}" >> ${SCRIPT_DIRECTORY}/.env
echo "HTTPS_PORT=${https_port}" >> ${SCRIPT_DIRECTORY}/.env
echo "NGINX_VERSION=${nginx_version}" >> ${SCRIPT_DIRECTORY}/.env
echo "PROXY_PROVIDER=${proxy_provider}" >> ${SCRIPT_DIRECTORY}/.env
echo "PROXY_PROVIDER_VERSION=${proxy_provider_version}" >> ${SCRIPT_DIRECTORY}/.env

cd ${SCRIPT_DIRECTORY}
if [[ "${nginx_version}" == "latest" ]] || [[ "${proxy_provider_version}" == "latest" ]]; then
    docker-compose pull
fi

docker-compose up --detach --renew-anon-volumes --remove-orphans
cd ${CURRENT_DIRECTORY}
