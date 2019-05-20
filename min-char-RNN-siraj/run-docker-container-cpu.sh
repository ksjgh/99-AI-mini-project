#!/bin/bash

set -e

# Settings from environment
CONTAINER_NAME="DL-all-py27-cpu"
DOCKER_IMAGE="ksjdk/deep-learning:all-py27-opencv341-cpu"

# Check if container exist
if [ "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
	if [ "$(docker ps | grep ${CONTAINER_NAME})" ]; then
		
		echo "Attaching to running container...press ENTER"
		docker exec -it ${CONTAINER_NAME} bash $@
			
	else
		
	        echo "Restart container..."
	    	docker restart ${CONTAINER_NAME}

	    	echo "Attach container...press ENTER"
	    	docker attach ${CONTAINER_NAME}
			
	fi
else
	# Create new container
	echo "Create new container..."	

	docker run -it --rm \
	   -p 8888:8888 \
	   -p 6006:6006 \
	   -v $PWD:/home/project \
           --ipc=host \
	   --name ${CONTAINER_NAME} \
	   ${DOCKER_IMAGE} \
	   bash
	
fi


# for jupyter notebook : jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token= --notebook-dir='/home/project'
# for PyTorch :  --ipc=host
# for webcam connection : --privileged -v /dev/video/
