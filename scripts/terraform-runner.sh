#!/bin/bash
# Example: ./terraform-runner.sh "terraform.init(/dev/us-east-1/_frontend_apps/app1)"
# set -x # uncomment for debugging

osType=`uname`
INPUT="$1"
TEMPLATES_DIR="$PWD/_templates"


function check_terraform_status {
    local status="$1"
    local verb="$2"
    if [ "$status" == '0' ]; then
        echo "Info: 'terraform $verb' completed. Continuing..."
    else
        echo "Error: 'terraform $verb' failed. Exiting..."
        exit 1
    fi
}

function write_output_to_s3 {
    local output_file="$1"
    pathInBucket=${DIR}/log/`date +%s`.${VERB}
    contentType="application/octet-stream"
    if [ ${osType} == 'Linux' ]; then
        dateValue=`date -u +%a,\ %d\ %h\ %Y\ %T\ %Z`
    else
        dateValue=`date -jnu +%a,\ %d\ %h\ %Y\ %T\ %Z`
    fi
    resource="/${REMOTE_STATE_BUCKET_NAME}${pathInBucket}"

    stringToSign="PUT\n\n${contentType}\n${dateValue}\nx-amz-security-token:${token}\n/${REMOTE_STATE_BUCKET_NAME}${pathInBucket}"
    signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${aws_secret_access_key} -binary | base64`
    curl -X PUT -T "${output_file}" \
      -H "Host: ${REMOTE_STATE_BUCKET_NAME}.s3.amazonaws.com" \
      -H "Date: ${dateValue}" \
      -H "Content-Type: ${contentType}" \
      -H "Authorization: AWS ${aws_access_key_id}:${signature}" \
      -H "x-amz-security-token: ${token}" \
      https://${REMOTE_STATE_BUCKET_NAME}.s3.amazonaws.com${pathInBucket}
      echo "$REMOTE_STATE_BUCKET_NAME$pathInBucket" >> ./.log
      rm ${output_file}
}

if [ -z "$INPUT" ]; then
    echo "Error: no terraform.{action}(directory) specified, nothing to do..."
    exit 1
fi



echo "Step 1: Get terraform.{action}(directory) information:"

regex='^terraform.(.*)\((.*)\)'
if [[ "$INPUT" =~ $regex ]]; then
    VERB="${BASH_REMATCH[1]}"
    DIR="${BASH_REMATCH[2]}"
    ENV=$( echo "$DIR" | cut -d'/' -f2 )
    REGION=$( echo "$DIR" | cut -d'/' -f3 )
    DIR_FLAT="${DIR//\//_}"
else
    echo "Error: unable to parse input with regular expression. Exiting..."
    exit 1
fi

echo "Step 1: Get Credentials:"
# If running locally, make sure you have your AWS profile set properly in
# terraform.tfvars and it's pointing to a valid profile name in your ~/.aws/
# credentials file.

if [[ $OSTYPE != darwin* ]]; then
    echo "Info: I'm running from an EC2 Instance, I'll get my credentials from my meta-data url."
    #export AWS_ACCESS_KEY_ID="$aws_access_key_id"
    #export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
    #export AWS_SESSION_TOKEN="$token"
    local="false"
else
    echo "Info: I'm running on a local machine or a box that isn't on EC2, I'll get " \
         "my credentials from my AWS profile."
         local="true"
fi

if [ "$REGION" == '_global' ]; then
    REGION='us-east-1'
fi

if [ "$VERB" == 'init' ]; then
    REGION='us-east-1'
fi

export REPO_TREE="$DIR"
export TF_VAR_PROJECT_VARS_ROOT="$PWD/../terraform/_vars"
export TF_VAR_ENV_VARS_ROOT="$PWD/../terraform/$ENV/_vars"
export TF_VAR_CORE_ROOT="$PWD/../terraform/$ENV/$REGION/_core"
export TF_VAR_DIR="$DIR"
export TF_VAR_DIR_FLAT="$DIR_FLAT"
export TF_VAR_INTERNAL_APPS_ROOT="$PWD/../terraform/$ENV/$REGION/_internal_apps"
export TF_VAR_FRONTEND_APPS_ROOT="$PWD/../terraform/$ENV/$REGION/_frontend_apps"
export TF_VAR_BACKEND_APPS_ROOT="$PWD/../terraform/$ENV/$REGION/_backend_apps"
export TF_VAR_ENVIRONMENT="$ENV"
export TF_VAR_REGION="$REGION"
export AWS_REGION="$REGION"

if [[ -e "$PWD/common.properties" && -e "$PWD/${ENV}.properties" ]]; then
  echo "Sourcing.... common.properties"
  source "$PWD/common.properties"
  echo "Sourcing.... $PWD/${ENV}.properties"
  source "$PWD/${ENV}.properties"
else
  echo "Error: verify that files 'common.properties' and '$ENV.properties' exist."
  exit 1
fi

if [ -e "$PWD/${ENV}/${REGION}.properties" ]; then
    echo "Sourcing.... $PWD/${ENV}/${REGION}.properties"
    source "$PWD/${ENV}/${REGION}.properties"
fi

if [ "$local" == "true" ]; then
    aws_access_key_id=`cat ~/.aws/credentials | grep "$AWS_PROFILE_NAME" -A 5 | grep aws_access_key | awk '{print $3}'`
    aws_secret_access_key=`cat ~/.aws/credentials | grep "$AWS_PROFILE_NAME" -A 5 | grep aws_secret_access_key | awk '{print $3}'`
    token=`cat ~/.aws/credentials | grep "$AWS_PROFILE_NAME" -A 5 | grep aws_session_token | awk '{print $3}'`
else
  unset AWS_DEFAULT_PROFILE
  unset AWS_PROFILE
  unset AWS_PROFILE_NAME
fi

secrets_filename=${TF_VAR_PROJECT}-secrets-${ENV}.properties
aws s3 cp s3://${TF_VAR_OWNER_NAME}-${ENV}-tfconfig/${secrets_filename} ./${secrets_filename}
if [ $? -ne 0 ]; then
  echo "Downloading secrets failed $?"
  exit 1
fi
source ./${secrets_filename}
echo "Sourcing secrets: ${secrets_filename}"
rm ./${secrets_filename}
#echo ">>>>> ${TF_VAR_REPOSITORY_AUTH_DATA_URL}"

echo "Step 3: Run terraform with options"

## Execute shell in Jenkins (for reference)
## bash ./scripts/terraform-runner.sh ${ghprbPullDescription}

TFBIN="$TF_LOCATION/terraform"
TERRAFORM_DIR="$PWD/../terraform${DIR}"
TERRAFORM_REMOTE_STATE_DIR="$PWD/../terraform/$ENV/_global/_remote_state"

date_file=`date +%m%d%y%H%M%S`

case "$VERB" in
    get|apply|destroy)
        echo "Info: running terraform $VERB on $DIR in environment $ENV and region ${REGION}."
        cd "$TERRAFORM_DIR"
        "$TFBIN" "$VERB" -lock=false | tee "./$date_file.$VERB"
        write_output_to_s3 "./$date_file.$VERB"
        check_terraform_status "$?" "$VERB"
        ;;
    plan)
        echo "Info: running terraform $VERB on $DIR in environment $ENV and region ${REGION}."
        cd "$TERRAFORM_DIR"
        "$TFBIN" get | tee "./$date_file.$VERB"
        "$TFBIN" "$VERB" -lock=false | tee "./$date_file.$VERB"
        write_output_to_s3 "./$date_file.$VERB"
        check_terraform_status "$?" "$VERB"
        ;;
    init)
        echo "Info: running terraform $VERB on $DIR in environment $ENV and region ${REGION}."

        if [ ! -e "$TERRAFORM_DIR" ]; then
            echo "Info: directory '$TERRAFORM_DIR' does not exist. Creating..."
            mkdir -p "$TERRAFORM_DIR"
        fi
        echo "Info: directory '$TERRAFORM_DIR' exists. Continuing..."

        if [ ! -e "$TERRAFORM_DIR/_variables.tf" ]; then
            echo "Info: creating variables file '$TERRAFORM_DIR/_variables.tf'"
            cp "$TEMPLATES_DIR/_variables.tf" "$TERRAFORM_DIR/_variables.tf"
        fi
        if [ -e "$TERRAFORM_REMOTE_STATE_DIR/_locktable_$DIR_FLAT.tf" ]; then
            echo "Info: lock file '$TERRAFORM_REMOTE_STATE_DIR/_locktable_$DIR_FLAT.tf' already exists. Skipping..."
        else
            echo "Info: creating lock file '$TERRAFORM_REMOTE_STATE_DIR/_locktable_$DIR_FLAT.tf'"
            cat "$TEMPLATES_DIR/_locktable.tf" | \
                m4 -D OWNER_NAME="$OWNER_NAME" \
                   -D DIR_FLAT="$DIR_FLAT" \
                > "$TERRAFORM_REMOTE_STATE_DIR/_locktable_$DIR_FLAT.tf"
            cd "$TERRAFORM_REMOTE_STATE_DIR"
            "$TFBIN" get
            check_terraform_status "$?" 'get'
            "$TFBIN" apply
            check_terraform_status "$?" 'apply'
            cd "$TERRAFORM_DIR"
        fi

        cd "$TERRAFORM_DIR"

        if [ -e "$TERRAFORM_DIR/_backend.tf" ]; then
            echo "Info: backend file '$TERRAFORM_DIR/_backend.tf' already exists. Skipping..."
        else
            echo "Info: creating backend file '$TERRAFORM_DIR/_backend.tf'"
            cat "$TEMPLATES_DIR/_backend.tf" | \
                m4 -D REMOTE_STATE_BUCKET_NAME="$REMOTE_STATE_BUCKET_NAME" \
                   -D DIR="$DIR" \
                   -D OWNER_NAME="$OWNER_NAME" \
                   -D DIR_FLAT="$DIR_FLAT" \
                   -D REGION="$REGION" \
                > "$TERRAFORM_DIR/_backend.tf"
        fi

        "$TFBIN" init -lock=false | tee "./$date_file.$VERB"
        write_output_to_s3 "./$date_file.$VERB"
        check_terraform_status "$?" 'init'
        #rm -f terraform.tfstate*
        ;;
    clean)
        echo "Info: running terraform $VERB on $DIR in environment $ENV and region ${REGION}."
        echo ">>>>>>>>"
        echo ">>>>>>>> Do you want to CLEAN $DIR"
        echo ">>>>>>>> Confirm CLEAN by entering the ENV: '$ENV'"
        read RESPONSE
        if [ $RESPONSE == $ENV ]; then
          rm -f "$TERRAFORM_DIR/_backend.tf"
          rm -f "$TERRAFORM_DIR/_variables.tf"
          rm -f "$TERRAFORM_DIR/.log"
          rm -rf "$TERRAFORM_DIR/.terraform"
          rm -rf "$TERRAFORM_DIR/terraform.tfstate.backup"
        else
          echo "NOT CLEANING - Response: $RESPONSE"
          exit 1
        fi
        ;;
    init-remote)
        echo "Info: running terraform $VERB on $DIR in environment $ENV and region ${REGION}."
        echo "Info: running steps required to create remote S3 and initialize the remote state S3 Bucket:" \
             "$REMOTE_STATE_BUCKET_NAME"
        if [ ! -e "$TERRAFORM_REMOTE_STATE_DIR" ]; then
            echo "Info: directory '$TERRAFORM_REMOTE_STATE_DIR' does not exist. Creating..."
            mkdir -p "$TERRAFORM_REMOTE_STATE_DIR"
        fi
        if [ ! -f "$TERRAFORM_REMOTE_STATE_DIR/_remote_state.tf" ]; then
            echo "Info: creating remote state '$TERRAFORM_REMOTE_STATE_DIR/_remote_state.tf'"
            cat "$TEMPLATES_DIR/_remote_state.tf" | \
                m4 -D OWNER_NAME="$OWNER_NAME" \
                   -D DIR_FLAT="$DIR_FLAT" \
                   -D REMOTE_STATE_BUCKET_NAME="$REMOTE_STATE_BUCKET_NAME" \
                   -D REGION="$REGION" \
                   -D ENV="$ENV" \
                > "$TERRAFORM_REMOTE_STATE_DIR/_remote_state.tf"

            cd "$TERRAFORM_REMOTE_STATE_DIR"

            # "$TFBIN" get
            # check_terraform_status "$?" 'get'

            "$TFBIN" apply
            check_terraform_status "$?" 'apply'

            echo "Info: creating backend file '$TERRAFORM_DIR/_backend.tf'"
            cat "$TEMPLATES_DIR/_backend.tf" | \
                m4 -D REMOTE_STATE_BUCKET_NAME="$REMOTE_STATE_BUCKET_NAME" \
                   -D DIR="$DIR" \
                   -D OWNER_NAME="$OWNER_NAME" \
                   -D DIR_FLAT="$DIR_FLAT" \
                   -D REGION="$REGION" \
                > "$TERRAFORM_DIR/_backend.tf"

            "$TFBIN" init
            check_terraform_status "$?" 'init'
            rm -f terraform.tfstate*
        else
            echo "Info: '$TERRAFORM_REMOTE_STATE_DIR/_remote_state.tf' already exists," \
                 "so I'll stop what I'm doing."
        fi
        ;;
    *)
        echo "Error: cannot recognize the verb '$VERB'. Exiting..."
        exit 1
        ;;
esac

echo 'Info: finished.'
exit 0
