# see instructions followed at https://www.digitalocean.com/community/tutorials/how-to-install-ruby-2-1-0-and-sinatra-on-ubuntu-13-with-rvm


aptitude update
aptitude -y upgrade
aptitude install -y cvs subversion git-core mercurial

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable

source /etc/profile.d/rvm.sh

rvm install ruby-2.2.1
