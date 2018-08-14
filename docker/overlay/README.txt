-----------------------------------------------------------------------------
Building your image
-----------------------------------------------------------------------------

Go to the directory that has your Dockerfile and run the following command
to build the Docker image. The -t flag lets you tag your image so it's 
easier to find later using the docker images command:

  $ docker build -t <username>-<image-name> .

To list the Docker images, type:

  $ docker images

Your image will now be listed by Docker:

  REPOSITORY                      TAG        ID              CREATED
  node                            8          1934b0b038d1    5 days ago
  <username>-<image-name>         latest     d64d3505b0d2    1 minute ago

To print the running container output:

  $ docker logs <container id>

To launch your docker image:

  # -i: Keep STDIN open even if not attached
  # -t: Allocate a pseudo-tty

  $ docker run -it <image-id> <optional-command>

  # To start a container in detached mode

  $ docker run -d <image-id> <optional-command>

If you need to go inside a detatched container you can use the exec command:

  $ docker exec -it <container-id> /bin/bash

Or, to keep it running and avoid the exit:

  $ docker exec -d <container-id> --entrypoint '/bin/bash cat' 

