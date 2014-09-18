sudo apt-get -y install curl
curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3 --auto-dotfiles
gem install bundler
cd /vagrant
bundle install
