#!/bin/bash
read -p 'Branch name to set: ([topic,feature]/branch_name): ' branch 

cd cloud-api
sed  '/^replace/d' go.mod > temp && rm go.mod && mv temp go.mod
echo "replace github.com/shellhub-io/shellhub => github.com/shellhub-io/shellhub $branch" >> go.mod
echo "replace github.com/shellhub-io/shellhub/api => github.com/shellhub-io/shellhub/api $branch" >> go.mod
echo "replace github.com/shellhub-io/cloud => ../" >> go.mod
rm go.sum
GOPROXY=direct go get github.com/shellhub-io/shellhub@$branch
GOPROXY=direct go get github.com/shellhub-io/shellhub/api@$branch
cd ../admin-api
sed  '/^replace/d' go.mod > temp && rm go.mod && mv temp go.mod
echo "replace github.com/shellhub-io/shellhub => github.com/shellhub-io/shellhub $branch">> go.mod
echo "replace github.com/shellhub-io/shellhub/api => github.com/shellhub-io/shellhub/api $branch" >> go.mod
echo "replace github.com/shellhub-io/cloud => ../" >>go.mod

rm go.sum
GOPROXY=direct go get github.com/shellhub-io/shellhub@$branch
GOPROXY=direct go get github.com/shellhub-io/shellhub/api@$branch
