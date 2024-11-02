#!/usr/bin/env sh

set -e

echo '[info] Killing existing listening port process ...'

source ./.env || echo '[warn] Failed to read .env, fallback to default.'

echo '[info] PORT =' ${PORT:-3000}
portPID=$(netstat -ano | grep "LISTENING" | grep "TCP" | grep ":${PORT:-3000}" | awk '{print $5}' | sort -u)

if [[ -z "${portPID}" ]]; then 
    echo '[info] No existing listening port process found !'
else 
    echo '[info] Found existing listening port process:' ${portPID}
    taskkill -F -PID ${portPID} || echo '[warn] Failed to kill process, might be due to the process is not running.'
fi

echo 'Kill Completed !'