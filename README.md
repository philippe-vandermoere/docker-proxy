# Docker-proxy 

A HTTP reverse proxy for docker.

## Requirements

- [Docker](https://docs.docker.com/install/#supported-platforms) >= 18.09.6
- [Docker compose](https://docs.docker.com/compose/install) >= 1.24.0

## External dependency 

Web server:
- [Nginx](https://github.com/philippe-vandermoere/docker-proxy-nginx)

The web server is automatically configure when you add/remove a container by one of this provider 
- [PHP](https://github.com/philippe-vandermoere/docker-proxy-php)
- [GO](https://github.com/philippe-vandermoere/docker-proxy-go) (experimental)

## Installation

```bash
git clone https://github.com/philippe-vandermoere/docker-proxy
docker-proxy/start.sh
```

The script: 
- Ask you to configure docker-proxy:
  - `HTTP_PORT`: Define the listen http port of proxy (default 80).
  - `HTTPS_PORT`: Define the listen https port of proxy (default 443).
  - `NGINX_VERSION`: Define the version of nginx service (default latest).
  - `PROXY_PROVIDER`: Define the provider of proxy (default php).
  - `PROXY_PROVIDER_VERSION`: Define The version of provider of proxy (default latest).

- Start the stack

You can see the list of containers managed by proxy on http://127.0.0.1:${HTTP_PORT}

## Container configuration

### General configuration

- `com.docker-proxy.domain`: Define the domain of your service (require).
- `com.docker-proxy.port`: Define the http port of your service (default 80).
- `com.docker-proxy.path`: Define the domain path of your service (default /).
- `com.docker-proxy.sslcom.docker-proxy.ssl`: Define if you need https (default: false).

### Certificate provider Configuration

#### Github

- `com.docker-proxy.certificate-provider.name`: Define the provider name (require github).
- `com.docker-proxy.certificate-provider.token`: Define the github token (require).
- `com.docker-proxy.certificate-provider.repository`: Define the github repository (require).
- `com.docker-proxy.certificate-provider.reference`: Define the git reference (default: master).
- `com.docker-proxy.certificate-provider.certificate_path`: Define the path of certificate (require).
- `com.docker-proxy.certificate-provider.private_key_path`: Define the path of private key (require).

### Examples

#### HTTP

```docker
version: '3.5'
services:
    nginx:
        image: nginx:1.16.0-alpine
        labels:
            com.docker-proxy.domain: test.loc
```

#### HTTPS generate self-signed certificate

```docker
version: '3.5'
services:
    nginx:
        image: nginx:1.16.0-alpine
        labels:
            com.docker-proxy.domain: test.loc
            com.docker-proxy.ssl: true
```

#### HTTPS download certificate from github

```docker
version: '3.5'
services:
    nginx:
        image: nginx:1.16.0-alpine
        labels:
            com.docker-proxy.domain: test.loc
            com.docker-proxy.ssl: true
            com.docker-proxy.certificate-provider.name: github
            com.docker-proxy.certificate-provider.token: {github_token}
            com.docker-proxy.certificate-provider.repository: {github_orga}/{github_repository}
            com.docker-proxy.certificate-provider.certificate_path: {github_certificate_path}
            com.docker-proxy.certificate-provider.private_key_path: {github_private_key_path}
```
