#!/bin/sh

export PLUGIN="vault-plugin-secrets-gcp"
export PLUGIN_GOPATH="github.com/hashicorp/$PLUGIN"

export GOPATH=$PWD
export PATH=$PATH:$GOPATH/bin

mkdir -p src/$PLUGIN_GOPATH
git clone $PLUGIN src/$PLUGIN_GOPATH

# Generate new files
echo "Running go generate for IAM API library"
go generate $PLUGIN_GOPATH/plugin/iamutil
cd src/github.com/hashicorp/$PLUGIN
make bootstrap

# Make sure it builds
RESULT=$(make dev)
if [ "$RESULT" ]; then
  echo "Unable to build, stopping"
  exit 1
else
  if [ "$(git ls-files -m)" ]; then
    git config --global user.email "emilyye@google.org"
    git config --global user.name "Emily Ye"

    git add plugin/iamutil/iam_resources_generated.go
    git commit -m "Autoupdate to generated IAM APIs $(date "+%D")"
  else
    echo "no changes detected"
  fi
fi

cd $GOPATH
mv src/$PLUGIN_GOPATH/* ./updated-files
ls -la updated-files

  