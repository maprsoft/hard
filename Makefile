PROJECT = titan
ENV     = lab
SERVICE = hardening

AWS_REGION      = us-east-1
AWS_ACCOUNT     = $(shell aws sts get-caller-identity | jq -r .Account)
BUILD_TIMESTAMP = $(shell date '+%Y%m%d%H%M%S')

#JENKINS_IP   = $(shell aws secretsmanager get-secret-value --secret-id "arn:aws:secretsmanager:${AWS_REGION}:${AWS_ACCOUNT}:secret:${PROJECT}-${ENV}-${SERVICE}" --region "${AWS_REGION}" --version-stage AWSCURRENT --query SecretString --output text | jq -r .JENKINS_IP)
#JENKINS_USER = $(shell aws secretsmanager get-secret-value --secret-id "arn:aws:secretsmanager:${AWS_REGION}:${AWS_ACCOUNT}:secret:${PROJECT}-${ENV}-${SERVICE}" --region "${AWS_REGION}" --version-stage AWSCURRENT --query SecretString --output text | jq -r .JENKINS_USER)
#JENKINS_PASS = $(shell aws secretsmanager get-secret-value --secret-id "arn:aws:secretsmanager:${AWS_REGION}:${AWS_ACCOUNT}:secret:${PROJECT}-${ENV}-${SERVICE}" --region "${AWS_REGION}" --version-stage AWSCURRENT --query SecretString --output text | jq -r .JENKINS_PASS)
#CLIENT_USER  = $(shell aws secretsmanager get-secret-value --secret-id "arn:aws:secretsmanager:${AWS_REGION}:${AWS_ACCOUNT}:secret:${PROJECT}-${ENV}-${SERVICE}" --region "${AWS_REGION}" --version-stage AWSCURRENT --query SecretString --output text | jq -r .CLIENT_USER)
JENKINS_IP   = 52.200.217.126
JENKINS_USER = master
JENKINS_PASS = a6HMq6DjcT7vc2zv
CLIENT_USER  = client
CLIENT_PASSWORD  = gDMTtYAGP3f82We7


DOCKER_UID  = $(shell id -u)
DOCKER_GID  = $(shell id -g)
DOCKER_USER = $(shell whoami)

dependencies:
	@echo 'DOCKER_USER:x:DOCKER_UID:DOCKER_GID::/app:/sbin/nologin' > passwd
	@sed -i 's/DOCKER_USER/'"${DOCKER_USER}"'/g' passwd
	@sed -i 's/DOCKER_UID/'"${DOCKER_UID}"'/g' passwd
	@sed -i 's/DOCKER_GID/'"${DOCKER_GID}"'/g' passwd

build: dependencies
	@docker build -t ${PROJECT}-${ENV}-${SERVICE}:base -f docker/base/Dockerfile .
	@docker build -t ${PROJECT}-${ENV}-${SERVICE}:build --build-arg IMAGE=${PROJECT}-${ENV}-${SERVICE}:base -f docker/build/Dockerfile .
	@docker build -t ${PROJECT}-${ENV}-${SERVICE}:latest --build-arg IMAGE=${PROJECT}-${ENV}-${SERVICE}:base -f docker/latest/Dockerfile .
	@docker run --rm -u "${DOCKER_UID}":"${DOCKER_GID}" -v $(shell pwd)/passwd:/etc/passwd:ro -v $(shell pwd)/app:/app ${PROJECT}-${ENV}-${SERVICE}:build

scan:
	@scripts/scan.sh ${JENKINS_IP} ${JENKINS_USER} ${JENKINS_PASS} ${CLIENT_USER} ${BUILD_TIMESTAMP}

report: dependencies
	@scripts/report.sh
	@rm -rf app/report.pdf
	@docker run --rm -u "${DOCKER_UID}":"${DOCKER_GID}" -v $(shell pwd)/passwd:/etc/passwd:ro -v $(shell pwd)/app:/app ${PROJECT}-${ENV}-${SERVICE}:latest