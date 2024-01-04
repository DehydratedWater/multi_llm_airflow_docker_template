#!/bin/bash

docker kill llm-server-1
docker kill llm-server-2
docker kill llm-server-3
# docker kill llm-server-4
docker compose down