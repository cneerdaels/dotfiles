#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
ln -s ${BASEDIR}/bashrc ~/.bashrc
ln -s ${BASEDIR}/profile ~/.profile
# git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig
