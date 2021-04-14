DOCKER_NAME:=monodev
DOCKER_VOLUME_SRC=/tmp/${DOCKER_NAME}-buster
# User data
DOCKER_USER:=muser
DOCKER_USER_ID:=1001
DOCKER_USER_PASSWORD:=test1234
DOCKER_GROUP:=musers
DOCKER_GROUP_ID:=1001

all: build run

volume:
	mkdir -p ${DOCKER_VOLUME_SRC}
	cp -r MyApp ${DOCKER_VOLUME_SRC}
	chown -R ${DOCKER_USER_ID}:${DOCKER_GROUP_ID} ${DOCKER_VOLUME_SRC}

clean_volume: ${DOCKER_VOLUME_SRC}
	rm -rf ${DOCKER_VOLUME_SRC}

build:
	docker build \
		--build-arg AUSER=${DOCKER_USER} \
		--build-arg AUSER_ID=${DOCKER_USER_ID} \
		--build-arg AUSER_PASSWORD=${DOCKER_USER_PASSWORD} \
		--build-arg AGROUP=${DOCKER_GROUP} \
		--build-arg AGROUP_ID=${DOCKER_GROUP_ID} \
		-t ${DOCKER_NAME}:buster .

xorgHosts:
	xhost +

run: xorgHosts
	docker run -ti --rm \
		-e DISPLAY=${DISPLAY} \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-v ${DOCKER_VOLUME_SRC}:/mnt/data \
		--device /dev/dri \
		--device /dev/snd \
		--hostname=${DOCKER_NAME}-buster \
		--net=host \
		--name=${DOCKER_NAME} \
		${DOCKER_NAME}:buster

clean:
	docker image rm ${DOCKER_NAME}:buster
