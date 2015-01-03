Apache PHP DEV Docker image
===========================

A Docker image included with apache and php which can be used for development.

* Apache and PHP (see [yoshz/apache-php](https://registry.hub.docker.com/u/yoshz/apache-php/))
* Openjdk 7 (required when you use this image as Jenkins slave)
* Phing 2.9.1
* Phpunit 4.4.1
* PHP Checkstyle 1.5.5 (including standards for Drupal and Symfony2)
* Ruby 1.9.3
* Rubygems 2.4.5
* Bundler 1.7.10


Start a new container
---------------------

It is possible to autocreate a new system user on startup: 

    docker run -p 8000:80 \
        -v www:/var/www \
        -e USER_CREATE=`id -un` \
        -e USER_PUBLIC_KEY=`cat ~/.ssh/id_rsa.pub` \
        -e GIT_NAME=username \
        -e GIT_EMAIL=username@domain \
        yoshz/apache-php-dev

The following optional environment variables are available:

* *USER_CREATE*: Name of the user to create
* *USER_PUBLIC_KEY*: Public key to attach to the system user
* *USER_PASSWORD*: Password to attach to the system user
* *GIT_NAME*: GIT username to attach to system user
* *GIT_EMAIL*: GIT email to attach to system user

The user will be created with sudo rights on apachectl.
