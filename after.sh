#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.


if [ ! -f /usr/local/extra_homestead_software_installed ]; then

    echo "setting up swapspace (4GB)"

    # Create the Swap file
    fallocate -l 4G /swapfile

    # Set the correct Swap permissions
    chmod 600 /swapfile

    # Setup Swap space
    mkswap /swapfile

    # Enable Swap space
    swapon /swapfile

    # Make the Swap file permanent
    echo "/swapfile   none    swap    sw    0   0" | tee -a /etc/fstab

    # Add some swap settings:
    printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf && sysctl -p

    echo 'installing some extra software...'
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
    # install imagemagick
    #
    sudo apt-get install imagemagick -y
    sudo apt-get install php5-imagick -y
    
    #
    # install rvm
    #
    sudo gem install sass
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    curl -L https://get.rvm.io | bash -s stable
    
    #
    # install ruby 2.1.2
    #
    /usr/local/rvm/bin/rvm install ruby-2.1.2
    /usr/local/rvm/bin/rvm use 2.1.2 --default
    echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
    sudo chgrp -R vagrant /usr/local/rvm/gems/ruby-2.1.2/bin
    sudo chmod -R 770 /usr/local/rvm/gems/ruby-2.1.2/bin
    sudo chgrp -R vagrant /usr/local/rvm/user
    sudo chmod -R 770 /usr/local/rvm/user 
    

    # install elasticsearch (instructions copied from https://github.com/fideloper/Vaprobash/blob/master/scripts/elasticsearch.sh)	
    # Set some variables
    ELASTICSEARCH_VERSION=1.4.2 # Check http://www.elasticsearch.org/download/ for latest version

    sudo apt-get install -qq openjdk-7-jre-headless

    wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.deb
    sudo dpkg -i elasticsearch-$ELASTICSEARCH_VERSION.deb
    rm elasticsearch-$ELASTICSEARCH_VERSION.deb

    # Configure Elasticsearch for development purposes (1 shard/no replicas, don't allow it to swap at all if it can run without swapping)
    sudo sed -i "s/# index.number_of_shards: 1/index.number_of_shards: 1/" /etc/elasticsearch/elasticsearch.yml
    sudo sed -i "s/# index.number_of_replicas: 0/index.number_of_replicas: 0/" /etc/elasticsearch/elasticsearch.yml
    sudo sed -i "s/# bootstrap.mlockall: true/bootstrap.mlockall: true/" /etc/elasticsearch/elasticsearch.yml
    sudo service elasticsearch restart

    # Configure to start up Elasticsearch automatically
    sudo update-rc.d elasticsearch defaults 95 10
    
    #
    # aliases
    #
    echo "alias project-init='composer install;php artisan local:init;bundle install;npm install;gulp compile'" >> /home/vagrant/.zshrc
    echo "alias t='vendor/bin/codecept run'" >> /home/vagrant/.zshrc
    echo "alias mysqladmin='mysql -u homestead -psecret'" >> /home/vagrant/.zshrc
    
    #
    # remember that the extra software is installed
    #    
    touch /usr/local/extra_homestead_software_installed
else    
    echo "extra software already installed... moving on..."
fi

