#!/bin/bash

cd /www/

git reset --hard
git fetch -p
git clean -fd
git checkout master
git pull --rebase origin master