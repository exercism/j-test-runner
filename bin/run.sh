#!/usr/bin/env sh

./bin/run.ijs $1 $2 $3
cat $3"results.json"
