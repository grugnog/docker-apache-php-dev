FROM yoshz/apache-php
MAINTAINER Yosh de Vos "yosh@elzorro.nl"

# Install xdebug, sshd, openjdk-7 and ruby
RUN apt-get update && \
    apt-get -yq install php5-xdebug openssh-server openjdk-7-jre-headless ruby ruby-dev build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd

# Add supervisor configuration for sshd
ADD supervisord.conf /etc/supervisor/conf.d/sshd.conf

# Configure git
RUN git config --system alias.lol "log --pretty=oneline --abbrev-commit --graph --decorate --all"

# Enable xdebug
RUN php5enmod xdebug

# Install phpunit and phpcs
RUN composer global require phpunit/phpunit squizlabs/php_codesniffer && \
    git clone  git://github.com/escapestudios/Symfony2-coding-standard.git $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Symfony2 && \
    git clone --branch 7.x-2.x http://git.drupal.org/project/coder.git /tmp/coder && \
    cp -a /tmp/coder/coder_sniffer/Drupal $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/ && \
    rm -rf /tmp/coder

# Install bundler
RUN gem install rubygems-update bundler

# Add entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod 0555 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
CMD ["/usr/bin/supervisord"]
