#!/bin/bash

JENKINS_IP=$1
JENKINS_USER=$2
JENKINS_PASS=$3
BUILD_TIMESTAMP=$4
#IPADDRESS=$(/sbin/ip -o -4 addr list wlo1 | awk '{print $4}' | cut -d/ -f1)
IPADDRESS=$(curl ipinfo.io/ip)

#######################
### start hardening ###
#######################

## 1.1.2 - hard001_filesystem_ensure_tmp_is_configured
TEST_01=$(findmnt -n /tmp | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard001="ok"
else
  hard001="error"
fi

## 1.1.10 - hard002_filesystem_ensure_separate_partition_exists_for_var
TEST_01=$(findmnt -n /var | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard002="ok"
else
  hard002="error"
fi

## 1.1.11 - hard003_filesystem_ensure_separate_partition_exists_for_var_tmp
TEST_01=$(findmnt -n /var/tmp | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard003="ok"
else
  hard003="error"
fi

## 1.1.15 - hard004_filesystem_ensure_separate_partition_exists_for_var_log
TEST_01=$(findmnt -n /var/log | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard004="ok"
else
  hard004="error"
fi

## 1.1.16 - hard005_filesystem_ensure_separate_partition_exists_for_var_log_audit
TEST_01=$(findmnt -n /var/log/audit | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard005="ok"
else
  hard005="error"
fi

## 1.1.17 - hard006_filesystem_ensure_separate_partition_exists_for_home
TEST_01=$(findmnt -n /home | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard006="ok"
else
  hard006="error"
fi

## 1.1.23 - hard007_filesystem_disable_automounting
TEST_01=$(systemctl show "autofs.service" | grep -i unitfilestate=enabled | wc -l)

if [ "${TEST_01}" = "0" ]; then
  hard007="ok"
else
  hard007="error"
fi

## 1.7.5 - hard008_os_ensure_permissions_on_etc_issue_are_configured
TEST_01=$(stat -c %U /etc/issue)
TEST_02=$(stat -c %G /etc/issue)

if [ "${TEST_01}" = "root" ] && [ "${TEST_02}" = "root" ]; then
  hard008="ok"
else
  hard008="error"
fi

## 3.2.1 - hard009_network_ensure_ip_forwarding_is_disabled
TEST_01=$(sysctl net.ipv4.ip_forward | cut -d "=" -f2 | tr -d ' ')

if [ "${TEST_01}" = "0" ]; then
  hard009="ok"
else
  hard009="error"
fi

## 3.3.8 - hard010_network_ensure_TCP_SYN_Cookies_is_enabled
TEST_01=$(sysctl net.ipv4.tcp_syncookies | cut -d "=" -f2 | tr -d ' ')

if [ "${TEST_01}" = "1" ]; then
  hard010="ok"
else
  hard010="error"
fi

## 4.2.1.3 - hard011_auditd_ensure_rsyslog_default_file_permissions_configured
TEST_01=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf | grep 0640 | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard011="ok"
else
  hard011="error"
fi

## 4.2.2.1 - hard012_auditd_ensure_journald_is_configured_to_send_logs_to_rsyslog
TEST_01=$(grep -E ^\s*ForwardToSyslog /etc/systemd/journald.conf | grep ForwardToSyslog | grep yes | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard012="ok"
else
  hard012="error"
fi

## 5.1.2 - hard013_security_ensure_permissions_on_etc_crontab_are_configured
TEST_01=$(stat -c %U /etc/crontab)
TEST_02=$(stat -c %G /etc/crontab)

if [ "${TEST_01}" = "root" ] && [ "${TEST_02}" = "root" ]; then
  hard013="ok"
else
  hard013="error"
fi

## 5.3.1 - hard014_security_ensure_permissions_on_etc_ssh_sshd_config_are_configured
TEST_01=$(stat -c %U /etc/ssh/sshd_config)
TEST_02=$(stat -c %G /etc/ssh/sshd_config)

if [ "${TEST_01}" = "root" ] && [ "${TEST_02}" = "root" ]; then
  hard014="ok"
else
  hard014="error"
fi

## 5.3.6 - hard015_security_ensure_SSH_X11_forwarding_is_disabled
TEST_01=$(grep -Ei '^\s*x11forwarding\s+yes' /etc/ssh/sshd_config | wc -l)

if [ "${TEST_01}" = "0" ]; then
  hard015="ok"
else
  hard015="error"
fi

## 5.3.10 - hard016_security_ensure_SSH_root_login_is_disabled
TEST_01=$(cat /etc/ssh/sshd_config | grep PermitRootLogin | grep -v ^\# | grep no | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard016="ok"
else
  hard016="error"
fi

## 5.3.11 - hard017_security_ensure_SSH_PermitEmptyPasswords_is_disabled
TEST_01=$(cat /etc/ssh/sshd_config | grep PermitEmptyPasswords | grep -v ^\# | grep no | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard017="ok"
else
  hard017="error"
fi

## 5.3.19 - hard018_security_ensure_SSH_PAM_is_enabled
TEST_01=$(cat /etc/ssh/sshd_config | grep UsePAM | grep -v ^\# | grep yes | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard018="ok"
else
  hard018="error"
fi

## 5.3.20 - hard019_security_ensure_SSH_AllowTcpForwarding_is_disabled
TEST_01=$(cat /etc/ssh/sshd_config | grep AllowTcpForwarding | grep -v ^\# | grep no | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard019="ok"
else
  hard019="error"
fi

## 5.3.22 - hard020_security_ensure_SSH_MaxSessions_is_limited
TEST_01=$(cat /etc/ssh/sshd_config | grep MaxSessions | grep -v ^\# | grep 10 | wc -l)

if [ "${TEST_01}" = "1" ]; then
  hard020="ok"
else
  hard020="error"
fi

########################
### finish hardening ###
########################

########################
### publish hardening ###
########################
rm -rf /tmp/data.txt

CLIENT_OS=$(uname -s)
CLIENT_ARC=$(uname -m)

echo '{
  "ipaddress":"'${IPADDRESS}'",
  "os":"'${CLIENT_OS}'",
  "architecture":"'${CLIENT_ARC}'",
  "hard001_filesystem":"'${hard001}'",
  "hard002_filesystem":"'${hard002}'",
  "hard003_filesystem":"'${hard003}'",
  "hard004_filesystem":"'${hard004}'",
  "hard005_filesystem":"'${hard005}'",
  "hard006_filesystem":"'${hard006}'",
  "hard007_filesystem":"'${hard007}'",
  "hard008_os":"'${hard008}'",
  "hard009_network":"'${hard009}'",
  "hard010_network":"'${hard010}'",
  "hard011_auditd":"'${hard011}'",
  "hard012_auditd":"'${hard012}'",
  "hard013_security":"'${hard013}'",
  "hard014_security":"'${hard014}'",
  "hard015_security":"'${hard015}'",
  "hard016_security":"'${hard016}'",
  "hard017_security":"'${hard017}'",
  "hard018_security":"'${hard018}'",
  "hard019_security":"'${hard019}'",
  "hard020_security":"'${hard020}'"
}' > /tmp/data.txt

sshpass -p "${JENKINS_PASS}" scp -o "StrictHostKeyChecking no" -r /tmp/data.txt ${JENKINS_USER}@${JENKINS_IP}:/tmp/${BUILD_TIMESTAMP}/${IPADDRESS}.txt
rm -rf /tmp/data.txt