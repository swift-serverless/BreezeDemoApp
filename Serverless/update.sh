make build_lambda
make cp_lambda_to_sls_build_local
BUILD_ARCH=`uname -m`
if [ $BUILD_ARCH = "arm64" ];
then
    serverless deploy -f createFormAPI
    serverless deploy -f readFormAPI
    serverless deploy -f updateFormAPI
    serverless deploy -f deleteFormAPI
    serverless deploy -f listFormAPI
else
    serverless deploy -f createFormAPI -c serverless-x86_64.yml
    serverless deploy -f readFormAPI -c serverless-x86_64.yml
    serverless deploy -f updateFormAPI -c serverless-x86_64.yml
    serverless deploy -f deleteFormAPI -c serverless-x86_64.yml
    serverless deploy -f listFormAPI -c serverless-x86_64.yml
fi
