#!/bin/bash

set -e

# Settings from environment
CONTAINER_NAME="deep-learning-remote-jupyter"
DOCKER_IMAGE="ksjdk/deep-learning:cu90-all-py36-opencv341-v3-remote-jupyter"

# Check if container exist
if [ "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
	if [ "$(docker ps | grep ${CONTAINER_NAME})" ]; then
		echo "Attaching to running container...press ENTER"
  		nvidia-docker exec -it ${CONTAINER_NAME} bash $@

	else
	        echo "Restart container..."
	    	nvidia-docker restart ${CONTAINER_NAME}

	    	echo "Attach container...press ENTER"
	    	nvidia-docker attach ${CONTAINER_NAME}	
	fi
else
	# Create new container
	echo "Create new container..."

	nvidia-docker run -it --rm \
	   -p 9999:9999 \
	   -v $PWD:/home/project \
           --privileged -v /dev/video/ \
	   --ipc=host \
	   --name ${CONTAINER_NAME} \
	   ${DOCKER_IMAGE} \
	   bash

fi


# for jupyter notebook : jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token= --notebook-dir='/home/project'
# for PyTorch :  --ipc=host
# for webcam connection : --privileged -v /dev/video/
#--env="QT_X11_NO_MITSHM=1" \
#--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#--env="DISPLAY" \
