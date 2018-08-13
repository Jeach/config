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

