#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PARENT="$(dirname "$SCRIPT_DIR")"
if [[ ! $# -eq 1 ]]; then 
    echo "either 'create', 'start', or 'bundle' should an the argument"
    exit 0
fi

CERT_PATH=$SCRIPT_DIR/root.pem

if [ -s $CERT_PATH ]; then
    echo "Using SSL_CERT_DIR=$CERT_PATH"
    export SSL_CERT_DIR=$CERT_PATH
fi

DOCS_PATH="$PARENT/docs"

if [[ "${1,,}" == "create" ]]; then
    # see https://www.kenmuse.com/blog/avoiding-dubious-ownership-in-dev-containers/
    git config --global --add safe.directory $PARENT

    cd $DOCS_PATH && bundle install
    exit 0
fi

if [[ ("${1,,}" == "bundle") || ("${1,,}" == "start") ]]; then
    npx --yes @redocly/cli bundle $DOCS_PATH/_data/openapi-split.yaml -o $DOCS_PATH/openapi.yaml
fi

if [[ "${1,,}" == "start" ]]; then
    cd $PARENT/docs
    bundle update 
    nohup bundle exec jekyll serve  --force_polling --livereload > $PARENT/jekyll.out 2>&1 &
    sleep 4
    tail $PARENT/jekyll.out
    echo "Jekyll started, to monitor see $PARENT/jekyll.out"
fi
