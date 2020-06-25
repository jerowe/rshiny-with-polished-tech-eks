#!/usr/bin/env bash

docker build -t eks-k8 .

docker run -it \
	-v "$(pwd):/project" \
	-v "$(pwd)/.aws:/root/.aws" \
	eks-k8 bash 
