#!/bin/bash
#Install some things
sudo apt-get install git mercurial curl

#Install some dotfiles.
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# bash
ln -fs ${BASEDIR}/bashrc ~/.bashrc
ln -fs ${BASEDIR}/profile ~/.profile
# git
ln -fs ${BASEDIR}/gitconfig ~/.gitconfig


#Download some things
wget https://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb
sudo dpkg -i google-chrome-unstable_current_amd64.deb
sudo apt-get -f install

if [ -d "$HOME/google-cloud-sdk" ]; then
    echo "Cloud sdk already installed. Updating..."
    gcloud components update

else
    curl https://sdk.cloud.google.com | bash
fi

#install golang
VERSION="1.4.2"
DFILE="go$VERSION.linux-amd64.tar.gz"
wget https://storage.googleapis.com/golang/$DFILE -P ~/Downloads
if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi
sudo tar -C /usr/local -xzf ~/Downloads/go$VERSION.linux-amd64.tar.gz
mkdir -p ~/go/{bin,pkg,src/github.com/mikecb}
