#!/bin/bash

JENKINS_IP=$1
JENKINS_USER=$2
JENKINS_PASS=$3
CLIENT_USER=$4
BUILD_TIMESTAMP=$5

# creando directorio de datos
mkdir -p /tmp/${BUILD_TIMESTAMP}/
chmod -R 777 /tmp/${BUILD_TIMESTAMP}/

# iniciando proceso de hardening
while read i; do
  # copiando script a los clientes
  sshpass -p "${CLIENT_PASSWORD}" ssh -o "StrictHostKeyChecking no" ${CLIENT_USER}@${i} 'rm -rf /tmp/check.sh'
  sshpass -p "${CLIENT_PASSWORD}" scp -o "StrictHostKeyChecking no" scripts/check.sh ${CLIENT_USER}@${i}:/tmp/ > /dev/null 2>&1
  # ejecutando hardening
  echo "escaneando: ${i}"
  sshpass -p "${CLIENT_PASSWORD}" ssh -o "StrictHostKeyChecking no" ${CLIENT_USER}@${i} /tmp/check.sh ${JENKINS_IP} ${JENKINS_USER} ${JENKINS_PASS} ${BUILD_TIMESTAMP} &
done < scripts/ips.txt

# imprimiendo directorio de resultado
echo "Hardening guardado en: /tmp/${BUILD_TIMESTAMP}"