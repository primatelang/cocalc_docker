#!/bin/bash

#docker build -t cocalc .

#wget -c https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh -O server/Anaconda2-5.0.1-Linux-x86_64.sh
docker run --name=cocalc -d -v ~/projects/cocalc/server:/projects -p 443:443 sagemathinc/cocalc
docker exec -it cocalc bash

