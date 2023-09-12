#! /bin/bash

while getopts "f:p:s:" flag;
do
  case "${flag}" in 
    f) file=$OPTARG;;
    p) port=$OPTARG;;
    s) server=$OPTARG;;
  esac
done

DIRNAME="$(dirname "${file}")" ; FILENAME="$(basename "${file}")"

printf "\033[1mLauching Streamlit...\n\n"

printf "\033[1mYou can now view your Streamlit app in your browser at:\n\n"

printf  "  \033[0;34m${server}\033[0;0m\n\n"

cd $DIRNAME

streamlit run $FILENAME --server.port $port --server.headless true | grep -vE "(You can now view your Streamlit app in your browser.|Network URL:|External URL:)"

