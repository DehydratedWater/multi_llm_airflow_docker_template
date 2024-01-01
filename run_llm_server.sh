#!/usr/bin/bash

docker remove llm-server

docker run --gpus all --network="host" -d -v "$(pwd)/models:/app/models" -p 5556:5556 --name llm-server llm-server