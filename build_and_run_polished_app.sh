#!/usr/bin/env bash

cd rshiny-app-polished-auth

docker build -t polished-shiny .

docker run -it \
    --rm \
    -p 3838:3838 -p 8080:8080 \
    -e POLISHED_APP_NAME="my_first_shiny_app" \
    -e POLISHED_API_KEY="XXXXXXXXXXXXXX" \
    jerowe/polished-tech:latest
