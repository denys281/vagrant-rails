#!/bin/bash
# Original script on https://github.com/orendon/vagrant-rails

# enable console colors
sed -i '1iforce_color_prompt=yes' ~/.bashrc

# disable docs during gem install
echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

# essentials
sudo apt-get -y update
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libcurl4-openssl-dev curl wget

# SQLite, Git and Node.js
sudo apt-get install -y libsqlite3-dev git nodejs

# Qt and xvfb-run for Capybara Webkit
sudo apt-get install -y libqtwebkit-dev xvfb

# ImageMagick and Rmagick
sudo apt-get install -y imagemagick libmagickwand-dev

# # MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server libmysqlclient-dev

# Memcached
sudo apt-get install -y memcached

# Redis
sudo apt-get install -y redis-server

# Postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get -y update

sudo apt-get install -y postgresql-9.5 postgresql-server-dev-9.5 postgresql-contrib-9.5
sudo sudo -u postgres psql -1 -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
sudo sudo -u postgres psql -1 -c "ALTER USER vagrant WITH SUPERUSER;"

# setup rbenv and ruby-build
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install ruby 2.3.1 and bundler
export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
export PATH="${RBENV_ROOT}/shims:${PATH}"
rbenv install 2.3.1
rbenv global 2.3.1
gem install bundler
rbenv rehash

sudo apt-add-repository -y ppa:fish-shell/release-2
sudo apt-get update
sudo apt-get -y install fish
curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.fish | fish

sudo apt-get -y install tmux
sudo apt-get -y install mc

git clone https://github.com/braintreeps/vim_dotfiles.git
cd vim_dotfiles
rake activate

# cleanup
sudo apt-get clean
