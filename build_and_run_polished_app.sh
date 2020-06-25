#!/usr/bin/env bash

cd rshiny-app-polished-auth

docker build -t polished-shiny .

docker run -it \
    --rm \
    -p 3838:3838 -p 8080:8080 \
    -e POLISHED_APP_NAME="my_first_shiny_app" \
    -e POLISHED_API_KEY="XXXXXXXXXXXXXXXXXXXXXX" \
    -e POLISHED_FIREBASE_API_KEY="" \
    -e POLISHED_FIREBASE_AUTH_DOMAIN="" \
    -e POLISHED_FIREBASE_PROJECT_ID="" \
    polished-shiny

# Or just run the prebuilt image
#docker run -it \
#    --rm \
#    -p 3838:3838 -p \
#    -e POLISHED_APP_NAME="my_first_shiny_app" \
#    -e POLISHED_API_KEY="XXXXXXXXXXXXXXXXXXXX" \
#    -e POLISHED_FIREBASE_API_KEY="" \
#    -e POLISHED_FIREBASE_AUTH_DOMAIN="" \
#    -e POLISHED_FIREBASE_PROJECT_ID="" \
#    jerowe/polished-tech:latest
