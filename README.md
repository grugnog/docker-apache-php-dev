Apache PHP DEV Docker image
===========================

A Docker image based on [yoshz/apache-php](https://registry.hub.docker.com/u/yoshz/apache-php/) installed with:

* Phpunit 4.3.5
* PHP Checkstyle 1.5.5 (including standards for Drupal and Symfony2)
* Ruby 1.9.3
* Rubygems 2.4.4
* Bundler 1.7.7

Start a new container
---------------------

To start a new container run:

    docker run -p 8001:80 -p 8022:22 \
        -v www:/var/www \
        -e DEV_USER=`id -un` \
        -e DEV_PASSWORD=password \
        -e GIT_NAME=username \
        -e GIT_EMAIL=username@domain \
        yoshz/apache-php-dev

The following optional environment variables are available:

* *DEV_USER*: System user to create
* *DEV_PASSWORD*: Password to attach to the system user
* *GIT_NAME*: GIT username to attach to system user
* *GIT_EMAIL*: GIT email to attach to system user

The system user will be created with sudo rights.
