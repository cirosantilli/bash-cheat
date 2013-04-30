#!/usr/bin/env bash

set -u # error on undefined variable
set -e # stop execution if one command goes wrong

usage()
{
    F="$(basename "$0")"
    echo "start new latex project locally and on github
    
usage: $F username reponame

example:

    $F username reponame

this:

- clones the latex template as reponame
- creates a github repo called reponame and pushes there
" 1>&2
}

if [ $# -ne 2 ]
then
    usage
    exit 1
else
    USERNAME="$1"
    NEW_REPO_NAME="$2"
    NEW_REPO_URL="git@github.com:$USERNAME/$NEW_REPO_NAME.git"  
    SHARED_REPO_URL="git://github.com/cirosantilli/latex-template.git" 

    git clone "$SHARED_REPO_URL" "$NEW_REPO_NAME"
    cd "$NEW_REPO_NAME"
    git submodule init
    git submodule update

    DESCRIPTION="`echo -e "\n#enter repo description\n#only first line will be considered" | vipe | head -n1 | perl -pe "chomp"`"
    echo -n "$DESCRIPTION"
    curl -u "$USERNAME" https://api.github.com/user/repos -d '{
        "name": "'"$NEW_REPO_NAME"'",
        "description": "'"$DESCRIPTION"'"
    }'

    git remote rm origin
    git remote add origin "$NEW_REPO_URL"
    git push -u origin master
    exit 0
fi
