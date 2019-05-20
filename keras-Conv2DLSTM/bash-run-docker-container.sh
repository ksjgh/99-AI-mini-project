#!/bin/bash

set -e

# Settings from environment
CONTAINER_NAME="keras-normal"

# DOCKER_IMAGE="ksjdk/deep-learning:anomaly-detection-and-localization"
DOCKER_IMAGE="ksjdk/deep-learning:cu90-all-py36-opencv341-v3.1"

# Check if container exist
if [ "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
	if [ "$(docker ps | grep ${CONTAINER_NAME})" ]; then
		echo "Attaching to running container...press ENTER"
		xhost +local:root​
  		nvidia-docker exec -it ${CONTAINER_NAME} bash $@
		xhost -local:root	
	else
	        echo "Restart container..."
	    	nvidia-docker restart ${CONTAINER_NAME}

	    	echo "Attach container...press ENTER"
		xhost +local:root​
	    	nvidia-docker attach ${CONTAINER_NAME}
		xhost -local:root		
	fi
else
	# Create new container
	echo "Create new container..."
	xhost +local:root​

	docker run -it --rm --runtime=nvidia \
	   -p 8888:8888 \
	   --env="DISPLAY" \
	   --env="QT_X11_NO_MITSHM=1" \
	   --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	   -v $PWD:/home/project \
           --privileged -v /dev/video/ \
	   --ipc=host \
	   --name ${CONTAINER_NAME} \
	   ${DOCKER_IMAGE} \
	   bash	

	xhost -local:root
fi


# for jupyter notebook : jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token= --notebook-dir='/home/project'
# for PyTorch :  --ipc=host
# for webcam connection : --privileged -v /dev/video/
