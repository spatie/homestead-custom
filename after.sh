#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.


if [ ! -f /usr/local/extra_homestead_software_installed ]; then
	echo 'installing some extra software'

    #
    # install zsh
    #
    apt-get install zsh -y
    
    #
    # install oh my zhs
    # (after.sh is run as the root user, but ssh is the vagrant user)
    #
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
    cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
    chsh -s /usr/bin/zsh vagrant
    
    #
    # use .dotfiles from osx
    #
    rm -f /home/vagrant/.zshrc
    ln -s /home/vagrant/.dotfiles/shell/.zshrc /home/vagrant/.zshrc    
    
    #
    # set up global gitignore
    #
    git config --global core.excludesfile ~/.gitignore_global
    echo ".DS_Store" > ~/.gitignore_global
    
    #
    # install imagemagick
    #
    sudo apt-get install imagemagick -y
    #sudo apt-get install php5-imagick -y
    apt-get install pkg-config libmagickwand-dev -y
    cd /tmp
    wget http://pecl.php.net/get/imagick-3.4.0RC2.tgz
    tar xvzf imagick-3.4.0RC2.tgz
    cd imagick-3.4.0RC2
    phpize
    ./configure
    make install
    rm -rf /tmp/imagick-3.4.0RC2*
    echo extension=imagick.so >> /etc/php/7.0/cli/php.ini
    service php7.0-fpm restart
    service nginx restart   
    
    #install pdftotext
    apt-get install poppler-utils -qq

    # install elasticsearch (instructions copied from https://github.com/fideloper/Vaprobash/blob/master/scripts/elasticsearch.sh)	
    # Set some variables
    #ELASTICSEARCH_VERSION=1.4.2 # Check http://www.elasticsearch.org/download/ for latest version

    #sudo apt-get install -qq openjdk-7-jre-headless

    #wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.deb
    #sudo dpkg -i elasticsearch-$ELASTICSEARCH_VERSION.deb
    #rm elasticsearch-$ELASTICSEARCH_VERSION.deb

    # Configure Elasticsearch for development purposes (1 shard/no replicas, don't allow it to swap at all if it can run without swapping)
    #sudo sed -i "s/# index.number_of_shards: 1/index.number_of_shards: 1/" /etc/elasticsearch/elasticsearch.yml
    #sudo sed -i "s/# index.number_of_replicas: 0/index.number_of_replicas: 0/" /etc/elasticsearch/elasticsearch.yml
    #sudo sed -i "s/# bootstrap.mlockall: true/bootstrap.mlockall: true/" /etc/elasticsearch/elasticsearch.yml
    #sudo service elasticsearch restart

    # Configure to start up Elasticsearch automatically
    #sudo update-rc.d elasticsearch defaults 95 10
    
    #
    # remember that the extra software is installed
    #    
    

    touch /usr/local/extra_homestead_software_installed
else    
    echo "extra software already installed... moving on..."
fi
