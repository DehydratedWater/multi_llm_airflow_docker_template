#!/usr/bin/bash

num=4
image="models/llama-2-13b-chat.Q4_K_M.gguf"
split=0

while getopts n:i: flag
do
    case "${flag}" in
        n) num=${OPTARG};;
        i) image=${OPTARG};;
        s) split=${OPTARG};;
    esac
done

echo "Parameter num: $num"
echo "Parameter image: $image"
echo "Parameter split: $image"

# docker run -it --entrypoint "python3 your_image_name -m llama_cpp.server --model models/llama-2-13b-chat.Q4_K_M.gguf --n_gpu_layers 200 --port 5556 --host 0.0.0.0"
# entrypoint="python3 -m llama_cpp.server --model $image --n_gpu_layers 200 --port 5556 --host 0.0.0.0"


for i in $(seq 1 $num)
do
    echo "Starting docker llm-server-$i"
    docker remove "/llm-server-$i"

    if [ "$split" -eq 1 ]; then
        docker run -e MODEL_NAME=$image --gpus all --ulimit memlock=16384:16384 --network qlora_semantic_extraction_connection_to_airflow -d -v "$(pwd)/models:/app/models" --name "llm-server-$i" llm-server
    else
        mod=$(($i % 2))
        echo "mod=$mod"
        device="device=$mod"
        docker run -e MODEL_NAME=$image --gpus $device --ulimit memlock=16384:16384 --network qlora_semantic_extraction_connection_to_airflow -d -v "$(pwd)/models:/app/models" --name "llm-server-$i" llm-server
    fi
    
done
# num=${1:-4}
# image=${2:-"models/llama-2-13b-chat.Q4_K_M.gguf"}

# echo "Parameter A: $num"
# echo "Parameter B: $image"



# docker run --gpus all --network qlora_semantic_extraction_connection_to_airflow -d -v "$(pwd)/models:/app/models" --name llm-server-1 llm-server
# docker run --gpus all --network qlora_semantic_extraction_connection_to_airflow -d -v "$(pwd)/models:/app/models" --name llm-server-2 llm-server
# docker run --gpus all --network qlora_semantic_extraction_connection_to_airflow -d -v "$(pwd)/models:/app/models" --name llm-server-3 llm-server
# # docker run --gpus all --network qlora_semantic_extraction_connection_to_airflow -d -v "$(pwd)/models:/app/models" --name llm-server-1 llm-server