apt-get update
apt-get -y install curl git
curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3 --auto-dotfiles
source /usr/local/rvm/scripts/rvm
gem install bundler
curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 0.10.32
nvm use 0.10.32
curl -L https://npmjs.org/install.sh | sh
npm install -g bower
cd /vagrant
bundle install
bower install --allow-root
nohup ruby /vagrant/gitHubStatusEditor.rb > /dev/null 2>&1 &
