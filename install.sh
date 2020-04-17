#!/bin/bash

# add alias in .bashrc

basepath=$(cd `dirname $0`; pwd)
echo $basepath
bashrc=$HOME/.bashrc
basepath=$basepath/dkBuilder.sh
sed -i '/alias dkBuilder/d' $bashrc

echo alias dkBuilder="$basepath" >> $bashrc
