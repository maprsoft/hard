#!/bin/bash

NUM_CLIENTS=$(cat scripts/ips.txt | wc -l)

NUM_FILESYSTEM_OK=$(cat /tmp/20220113183635/192.168.1.30.txt | grep filesystem | grep ok | wc -l)
NUM_FILESYSTEM_ERROR=$(cat /tmp/20220113183635/192.168.1.30.txt | grep filesystem | grep error | wc -l)

NUM_OS_OK=$(cat /tmp/20220113183635/192.168.1.30.txt | grep os | grep ok | wc -l)
NUM_OS_ERROR=$(cat /tmp/20220113183635/192.168.1.30.txt | grep os | grep error | wc -l)

NUM_NETWORK_OK=$(cat /tmp/20220113183635/192.168.1.30.txt | grep network | grep ok | wc -l)
NUM_NETWORK_ERROR=$(cat /tmp/20220113183635/192.168.1.30.txt | grep network | grep error | wc -l)

NUM_AUDITD_OK=$(cat /tmp/20220113183635/192.168.1.30.txt | grep auditd | grep ok | wc -l)
NUM_AUDITD_ERROR=$(cat /tmp/20220113183635/192.168.1.30.txt | grep auditd | grep error | wc -l)

NUM_SECURITY_OK=$(cat /tmp/20220113183635/192.168.1.30.txt | grep security | grep ok | wc -l)
NUM_SECURITY_ERROR=$(cat /tmp/20220113183635/192.168.1.30.txt | grep security | grep error | wc -l)

echo '{
  "filesystem": {
      "ok":"'${NUM_FILESYSTEM_OK}'",
      "error":"'${NUM_FILESYSTEM_ERROR}'"
  },
  "os": {
      "ok":"'${NUM_OS_OK}'",
      "error":"'${NUM_OS_ERROR}'"
  },
  "network": {
      "ok":"'${NUM_NETWORK_OK}'",
      "error":"'${NUM_NETWORK_ERROR}'"
  },
  "auditd": {
      "ok":"'${NUM_AUDITD_OK}'",
      "error":"'${NUM_AUDITD_ERROR}'"
  },
  "security": {
      "ok":"'${NUM_SECURITY_OK}'",
      "error":"'${NUM_SECURITY_ERROR}'"
  }
}' > /tmp/20220113183635/summary.json