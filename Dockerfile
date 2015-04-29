FROM yoshz/apache-php:1.5
MAINTAINER Yosh de Vos "yosh@elzorro.nl"

# Install supervisor, sshd, xdebug, ruby and various dev tools
RUN apt-get update && \
    apt-get -yq install supervisor openssh-server php5-xdebug ruby ruby-dev build-essential \
                acl graphviz sshpass && \
    mkdir -p /var/run/sshd

# Configure git
RUN git config --system alias.lol "log --pretty=oneline --abbrev-commit --graph --decorate --all"

# Configure php
RUN sed -i -e 's/^display_errors.*$/display_errors = On/' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

# Install bundler
RUN gem install rubygems-update bundler

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get -yq install nodejs

# Install bower and grunt
RUN npm install -g bower grunt-cli

# Enable xdebug
RUN echo "xdebug.max_nesting_level=500" >> /etc/php5/mods-available/xdebug.ini && \
    php5enmod xdebug

# Install phpunit and phpcs
RUN export COMPOSER_HOME=/usr/local/composer && \
    composer global require phing/phing phpunit/phpunit squizlabs/php_codesniffer && \
    git clone git://github.com/escapestudios/Symfony2-coding-standard.git $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Symfony2 && \
    git clone --branch 7.x-2.x http://git.drupal.org/project/coder.git /tmp/coder && \
    cp -a /tmp/coder/coder_sniffer/Drupal $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/ && \
    rm -rf /tmp/coder && \
    ln -s $COMPOSER_HOME/vendor/bin/phing /usr/local/bin/phing && \
    ln -s $COMPOSER_HOME/vendor/bin/phpunit /usr/local/bin/phpunit && \
    ln -s $COMPOSER_HOME/vendor/bin/phpcs /usr/local/bin/phpcs

# Install sfnt2woff
RUN apt-get install -yq fontforge zlib1g-dev && \
    wget http://people.mozilla.com/~jkew/woff/woff-code-latest.zip -P /tmp && \
    unzip -o /tmp/woff-code-latest.zip -d /tmp/sfnt2woff && \
    make -C /tmp/sfnt2woff/ && \
    mv /tmp/sfnt2woff/sfnt2woff /usr/local/bin/ && \
    rm -rf /tmp/woff-code-latest.zip /tmp/sfnt2woff

# Cleanup apt cache
RUN rm -rf /var/lib/apt/lists/*

# Add supervisor configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add entrypoint script
ADD entrypoint.sh /entrypoint.sh
RUN chmod 0500 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Expose ssh
EXPOSE 22

WORKDIR /var/www
CMD ["/usr/bin/supervisord"]
