#!/bin/bash
set -xe

echo "Executing package.sh..."

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

WORK_DIR=$(cd $(dirname "$SCRIPT_DIR") && pwd)

[[ -d dist ]] && rm -r dist

mkdir dist && cd dist

cp -r $WORK_DIR/src/* .

FILE=requirements.txt

if [[ -z "$RUNTIME" ]]; then
  echo "RUNTIME variable not set, defaulting to $(python --version)"
  pip=pip
else
  echo "RUNTIME set to '$RUNTIME'"
  pip="$RUNTIME -m pip"
fi

if [[ -f "$FILE" ]]; then
  echo "Installing dependencies..."
  echo "From: requirement.txt file exists..."
  $pip install -r "$FILE" -t . --no-compile
else
  echo "Error: requirement.txt does not exist!"
fi

echo "Removing unnecessary files for deterministic builds..."
find . -type d -name '__pycache__' -exec rm -rf {} +

if [[ ! $ACTOR == "terraform" ]]; then
  echo "Actor is not terraform! so zipping package"

  zip -r $WORK_DIR/lambda_deployment_package.zip .
  rm -r $WORK_DIR/dist
else
  echo "Actor is terraform! so done here"
fi

echo "Done!"
