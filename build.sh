#!/bin/bash

wget https://github.com/coder/code-server/releases/download/v4.16.1/code-server-4.16.1-amd64.rpm

sudo docker build -t oh-my-code:v1 .

sudo docker-compose up -d