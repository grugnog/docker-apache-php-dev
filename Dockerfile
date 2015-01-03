FROM yoshz/apache-php
MAINTAINER Yosh de Vos "yosh@elzorro.nl"

# Install xdebug, openjdk-7 and ruby
RUN apt-get update && \
    apt-get -yq install php5-xdebug openjdk-7-jre-headless ruby ruby-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

# Configure git
RUN git config --system alias.lol "log --pretty=oneline --abbrev-commit --graph --decorate --all"

# Configure php
RUN sed -i -e 's/^display_errors.*$/display_errors = On/' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

# Enable xdebug
RUN echo "xdebug.max_nesting_level=500" >> /etc/php5/mods-available/xdebug.ini && \
    php5enmod xdebug

# Install phpunit and phpcs
RUN composer global require phing/phing phpunit/phpunit squizlabs/php_codesniffer && \
    git clone  git://github.com/escapestudios/Symfony2-coding-standard.git $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Symfony2 && \
    git clone --branch 7.x-2.x http://git.drupal.org/project/coder.git /tmp/coder && \
    cp -a /tmp/coder/coder_sniffer/Drupal $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/ && \
    rm -rf /tmp/coder && \
    ln -s $COMPOSER_HOME/vendor/bin/phing /usr/local/bin/phing && \
    ln -s $COMPOSER_HOME/vendor/bin/phpunit /usr/local/bin/phpunit && \
    ln -s $COMPOSER_HOME/vendor/bin/phpcs /usr/local/bin/phpcs

# Install bundler
RUN gem install rubygems-update bundler

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
