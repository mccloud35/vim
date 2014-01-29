#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
ln -s $DIR/.vimrc ~/.vimrc
ln -s $DIR ~/.vim
git submodule init
git submodule update
