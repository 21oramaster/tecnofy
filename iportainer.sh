#!/bin/bash

docker pull portainer/portainer-ce:latest
docker run -d -p 9100:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
