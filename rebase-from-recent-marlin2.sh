#!/bin/bash

set -e

if [[ ! -z $(git status -s) ]]; then
    echo Uncommitted changes are present. Please commit first
    exit 1
fi

if [ "$1" == "push" ]; then
    # reintegrate
    git push --force-with-lease
    git pull --no-commit
    git pull --all --no-commit
    git push
else
    if ! (git remote | grep -q marlin-github); then
        git remote add -t 2.0.x marlin-github https://github.com/MarlinFirmware/Marlin.git
    fi

    git fetch marlin-github 2.0.x:marlin-2.0.x

    git pull
    git pull --all

    CUR_BRANCH=`git rev-parse --abbrev-ref HEAD`

    git checkout marlin-2.0.x
    git pull --no-commit marlin-github 2.0.x:marlin-2.0.x
    git push --set-upstream origin marlin-2.0.x

    git checkout "$CUR_BRANCH"
    git rebase -i -X patience -s recursive --autosquash marlin-github/2.0.x
fi
