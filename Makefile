DOCKER_NAME:=monodev
DOCKER_TAG:=debian-buster
DOCKER_VOLUME_SRC=/tmp/${DOCKER_NAME}_${DOCKER_NAME}

all: build run

volume:
	mkdir -p ${DOCKER_VOLUME_SRC}
	chown 101:101 ${DOCKER_VOLUME_SRC}

clean_volume: ${DOCKER_VOLUME_SRC}
	rm -rf ${DOCKER_VOLUME_SRC}

build:
	docker build -t ${DOCKER_NAME}-image:${DOCKER_TAG} .

run:
	docker run -ti --name ${DOCKER_NAME}-${DOCKER_TAG} \
		-e DISPLAY=${DISPLAY} \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ${DOCKER_VOLUME_SRC}:/mnt/data \
		--hostname=${DOCKER_NAME}:${DOCKER_TAG} \
		${DOCKER_NAME}-image:${DOCKER_TAG}

start:
	docker start ${DOCKER_NAME}-${DOCKER_TAG}

stop:
	docker stop ${DOCKER_NAME}-${DOCKER_TAG}

remove:
	-make stop
	docker container rm ${DOCKER_NAME}-${DOCKER_TAG}

clean:
	-make remove
	docker image rm ${DOCKER_NAME}=image:${DOCKER_TAG}
