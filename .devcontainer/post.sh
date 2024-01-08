#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PARENT="$(dirname "$SCRIPT_DIR")"
if [[ ! $# -eq 1 ]]; then 
    echo "either 'create' or 'start' should an the argument"
    exit 0
fi

CERT_PATH=$SCRIPT_DIR/root.pem

if [ -s $CERT_PATH ]; then
    echo "Using SSL_CERT_DIR=$CERT_PATH"
    export SSL_CERT_DIR=$CERT_PATH
fi



if [[ "${1,,}" == "create" ]]; then
    git config --global --add safe.directory $PARENT
    cd $PARENT/docs && bundle install
fi

if [[ "${1,,}" == "start" ]]; then
    cd $PARENT/docs && bundle update && bundle exec jekyll serve
fi