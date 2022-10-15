# Introduction to Containerization with Docker

In this exercise, we build a Docker image with a web application, run it, and terminate it finally. This can be done in a local VM or in a Cloud.

 1. Have a look to the steps in the Dockerfile what happens during the build process.
 2. Build an image with name `node-web-app`: 
	`docker build . -t node-web-app`
 3. List the images available on your host and verify that there is a `node-web-app` image:
        `docker images`
 4. Launch a container from image. We expose the port from the container to local port 49160:
	 `docker run -p 49160:8080 -d node-web-app`
 5. Now check the service you just created by opening http://<ip or hostname of your Docker host>:49160 in a browser.
 6. Check that the container is running and get the id:
	 `docker ps -a`
 7. Enter the container: 
	 `docker exec -it <container id> /bin/bash`
 8. Stop the container: 
	 `docker stop <container id>`
  9. Now have a look to the steps in Dockerfile-alpine and build an image with Alpine Linux as base image:
         `docker build -f Dockerfile-alpine -t node-web-app-alpine .`
 10. Check that image works like the same as the one with nodejs by starting a container and browsing to the index page.
 11. Compare the sizes of both images. Can you give a reason? (You need the history of the images...)
 12. Remove the containers: 
	 `docker rm <container id>`
 13. Remove the images from your host: 
	 `docker rmi node-web-app`
	 `docker rmi node-web-app-alpine`

References: 
 - https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
 - https://www.docker.com/
 - https://hub.docker.com
 - https://alpinelinux.org/
 - https://pkgs.alpinelinux.org/packages
