#!/bin/sh

export OUTPATH_DIR="updated_files"
export HOMEDIR=$PWD
export GOPATH=$PWD

export PLUGIN="vault-plugin-secrets-gcp"
export GEN_PKG="github.com/hashicorp/vault-plugin-secrets-gcp/plugin/iamutil"

echo "Generating IAM API library for vault-plugin-secrets-gcp..."

mkdir -p src/github.com/hashicorp/$PLUGIN
git clone $PLUGIN src/github.com/hashicorp/$PLUGIN

# Generate new files
go generate $GEN_PKG

cd src/github.com/hashicorp/$PLUGIN
if [ "$(git ls-files -m)" ]; then 
  git config --global user.email "emilyye@google.org"
  git config --global user.name "Emily Ye"

  git add plugin/iamutil/iam_resources_generated.go
  git commit -m "Autoupdate to generated IAM APIs $(date "+%D")"
else
  echo "no changes detected"
fi

cd $HOMEDIR
git clone $PLUGIN src/github.com/hashicorp/$PLUGIN
