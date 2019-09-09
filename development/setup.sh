#!/bin/bash
#set -e

# Setup Faktory password
faktory_password=$( cat /etc/faktory/password )
sed -i -E "s/[0-9a-zA-Z]+@localhost/$faktory_password@localhost/" start-service.sh
sed -i -E "s/[0-9a-zA-Z]+@localhost/$faktory_password@localhost/" start-worker.sh
