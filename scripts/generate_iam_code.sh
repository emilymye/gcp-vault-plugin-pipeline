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
if [ make dev ]; then 
  exit 1
else 
  cd src/github.com/hashicorp/$PLUGIN
  if [ "$(git ls-files -m)" ]; then 
    commit_changes()
  else
    echo "no changes detected"
  fi
end

cd $GOPATH
mv $PLUGIN_GOPATH/* ./updated-files
ls -la updated-files

commit_changes() {
  git config --global user.email "emilyye@google.org"
  git config --global user.name "Emily Ye"

  git add plugin/iamutil/iam_resources_generated.go
  git commit -m "Autoupdate to generated IAM APIs $(date "+%D")"
}