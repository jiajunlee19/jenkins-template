#!/usr/bin/env sh

set -e

echo '[info] Killing existing npm-run-start process ...'
kill $(cat .pidfile) || echo '[warn] Failed to kill process, might be due to the process is not running.'

echo 'Kill Completed !'