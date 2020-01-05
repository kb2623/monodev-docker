DOCKER_NAME:=monodev
DOCKER_TAG:=debian-buster
DOCKER_VOLUME_SRC=/tmp/${DOCKER_NAME}_${DOCKER_NAME}
# User data
DOCKER_USER:=mpiuser
DOCKER_USER_ID:=1001
DOCKER_GROUP:=mpiusers
DOCKER_GROUP_ID:=1001

all: build run

volume:
	mkdir -p ${DOCKER_VOLUME_SRC}
	chown -R ${DOCKER_USER_ID}:${DOCKER_GROUP_ID} ${DOCKER_VOLUME_SRC}

clean_volume: ${DOCKER_VOLUME_SRC}
	rm -rf ${DOCKER_VOLUME_SRC}

build:
	docker build \
		--build-arg AUSER=${DOCKER_USER} \
		--build-arg AUSER_ID=${DOCKER_USER_ID} \
		--build-arg AGROUP=${DOCKER_GROUP} \
		--build-arg AGROUP_ID=${DOCKER_GROUP_ID} \
		-t ${DOCKER_NAME}-image:${DOCKER_TAG} .

run:
	docker run -ti --name ${DOCKER_NAME}-${DOCKER_TAG} \
		-e DISPLAY=${DISPLAY} \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ${DOCKER_VOLUME_SRC}:/mnt/data \
		--hostname=${DOCKER_NAME}:${DOCKER_TAG} \
		${DOCKER_NAME}-image:${DOCKER_TAG}

start:
	docker start ${DOCKER_NAME}-${DOCKER_TAG}
	docker exec -ti ${DOCKER_NAME}-${DOCKER_TAG} /bin/bash

stop:
	docker stop ${DOCKER_NAME}-${DOCKER_TAG}

remove:
	-make stop
	docker container rm ${DOCKER_NAME}-${DOCKER_TAG}

clean:
	-make remove
	docker image rm ${DOCKER_NAME}=image:${DOCKER_TAG}
