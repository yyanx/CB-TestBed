#!/bin/sh

cd ../testbed
cat src/*.coffee | coffee --bare --compile --no-header --stdio > script.js
