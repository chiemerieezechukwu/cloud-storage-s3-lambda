#!bin/bash
set -xe

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

WORK_DIR=$(cd $(dirname "$SCRIPT_DIR") && pwd)

aws lambda update-function-code --function-name test_function_urls \
                                --zip-file fileb://$WORK_DIR/lambda_deployment_package.zip
