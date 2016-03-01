#!/bin/bash
# Update and install some fetchers.
sudo apt-get update -y && sudo apt-get dist-upgrade -y
sudo apt-get install git mercurial curl python-pip python3-pip

#Install some dotfiles.
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# bash
ln -fs ${BASEDIR}/bashrc ~/.bashrc
ln -fs ${BASEDIR}/profile ~/.profile
# git
ln -fs ${BASEDIR}/gitconfig ~/.gitconfig
#u2f
if [ -e "/etc/udev/rules.d/70-u2f.rules" ]; then
    echo "U2F alredy enabled, proceeding..."
else
    sudo cp ./70-u2f.rules /etc/udev/rules.d
fi

#Download some things
wget https://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb
sudo dpkg -i google-chrome-unstable_current_amd64.deb
sudo apt-get -f install

if [ -d "$HOME/google-cloud-sdk" ]; then
    echo "Cloud SDK already installed. Updating..."
    gcloud components update
else
    curl https://sdk.cloud.google.com | bash
    gcloud components update pkg-go pkg-python app preview beta alpha
fi

#install golang
GOVERSION="1.5.3"
DFILE="go$GOVERSION.linux-amd64.tar.gz"
wget https://storage.googleapis.com/golang/$DFILE -P ~/Downloads
if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi
sudo tar -C /usr/local -xzf ~/Downloads/$DFILE
mkdir -p ~/go/{bin,pkg,src/github.com/mikecb}

#install appengine sdk
APPVERSION="1.9.32"
AFILE="go_appengine_sdk_linux_amd64-$APPVERSION.zip"
wget https://storage.googleapis.com/appengine-sdks/featured/$AFILE -P ~/Downloads
mkdir -p ~/appengine
unzip ~/Downloads/$AFILE ~/appengine
echo "Log out and back in for changes to be reflected."

#Python dev
sudo apt-get install python3-numpy python3-scipy python3-matplotlib ipython3 ipython3-notebook cython3
sudo pip3 install yapf pystan
sudo pip3 install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.0-py3-none-linux_x86_64.whl

#install atom & packages
sudo add-apt-repository ppa:webupd8team/atom
sudo apt-get update
sudo apt-get install atom libzmq3-dev
apm install python-yapf git-plus minimap autocomplete-go go-plus hydrogen


#install android-studio
sudo apt-get install ubuntu-make
umake -v android
