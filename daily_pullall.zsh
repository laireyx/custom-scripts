#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
GRAY='\033[0;37m'
NC='\033[0m'

if [[ ! -e /tmp/daily-pullall-$(date +%u).sem ]]
then
    touch /tmp/daily-pullall-$(date +%u).sem

    echo pulling repositories...

    for project in ~/workspace/*
    do
        cd $project

        if ! (git remote | grep origin > /dev/null)
        then
            echo -e "[${GRAY}skip${NC}] $project"
            continue
        fi

        git stash push -q 2>&1 >/dev/null

        if (git pull -q origin develop --rebase)
        then
            # success
            echo -e "[${GREEN}success${NC}] $project"
        else
            # fail
            echo -e "[${RED}fail${NC}] $project"
            # cleanup
            git rebase --abort
        fi

        git stash pop -q 2>&1 >/dev/null
    done
fi
