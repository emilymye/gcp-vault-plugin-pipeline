#!/bin/sh

export PLUGIN="vault-plugin-secrets-gcp"
export PLUGIN_GOPATH="github.com/hashicorp/$PLUGIN"

export GOPATH=$PWD
echo "Generating IAM API library for vault-plugin-secrets-gcp..."

mkdir -p src/$PLUGIN_GOPATH
git clone $PLUGIN src/$PLUGIN_GOPATH

# Generate new files
go generate $PLUGIN_GOPATH/plugin/iamutil

# Make sure it builds
make build

cd src/github.com/hashicorp/$PLUGIN
if [ "$(git ls-files -m)" ]; then 
  git config --global user.email "emilyye@google.org"
  git config --global user.name "Emily Ye"

  git add plugin/iamutil/iam_resources_generated.go
  git commit -m "Autoupdate to generated IAM APIs $(date "+%D")"
else
  echo "no changes detected"
fi

cd $GOPATH
mv src/github.com/hashicorp/$PLUGIN/* ./updated-files


