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
    
    #
    # aliases
    #
    echo "alias project-init='composer install;php artisan local:init;bundle install;npm install;gulp compile'" >> /home/vagrant/.zshrc
    
    
    #
    # remember that the extra software is installed
    #    
    touch /usr/local/extra_homestead_software_installed
else    
	echo "extra software already installed... moving on...
fi

