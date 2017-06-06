#!/bin/bash
#Add some repos
sudo add-apt-repository ppa:webupd8team/atom

# Update and install some fetchers.
sudo apt-get update -y && sudo apt-get dist-upgrade -y
sudo apt-get install git mercurial curl python-pip python3-pip

#Install some dotfiles.
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# bash
ln -fs ${BASEDIR}/bashrc ~/.bashrc
source ~/.bashrc
ln -fs ${BASEDIR}/profile ~/.profile
source ~/.profile

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

# GCloud SDK
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-go google-cloud-sdk-datalab google-cloud-sdk-datastore-emulator google-cloud-sdk-pubsub-emulator google-cloud-sdk-bigtable-emulator kubectl 

#install golang
GOVERSION="1.8.1"
DFILE="go$GOVERSION.linux-amd64.tar.gz"
wget https://storage.googleapis.com/golang/$DFILE -P ~/Downloads
if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi
sudo tar -C /usr/local -xzf ~/Downloads/$DFILE
mkdir -p ~/go/{bin,pkg,src/github.com/mikecb}

#Python dev
sudo apt-get install python3-numpy python3-scipy python3-matplotlib ipython3 ipython3-notebook cython3
sudo pip3 install yapf pystan
sudo pip3 install --upgrade tensorflow

#Protobufs
sudo apt-get install protobuf-compiler
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}

#install atom & packages
sudo apt-get install atom
apm install python-yapf git-plus minimap autocomplete-go go-plus go-debug sort-lines language-yara language-protobuf autocomplete-json 

