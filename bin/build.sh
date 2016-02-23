#!/bin/sh

cd ..
cat src/*.coffee | coffee --bare --compile --no-header --stdio > script.js
