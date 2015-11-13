#!/bin/bash

REPO_PATH="/home/deeper-think.github.io.ws"
SOURCE_CODE="/home/deeper-think.github.io.ws/source_code"
DEPLOY_FROM="/home/deeper-think.github.io.ws/source_code/_site"
DEPLOY_TO="/var/www/html/"
BUILD_EXE="/usr/local/bin/jekyll"

if [ ! -d "$DEPLOY_FROM" ]
then 
    echo "DEPLOY_FROM NOT EXISTS!!"
    exit -1     
fi

if [ ! -d "$DEPLOY_TO" ]
then
    echo "DEPLOY_TO NOT EXISTS!!"
    exit -1
fi

if [ ! -d "$SOURCE_CODE" ]
then
    echo "SOURCE_CODE NOT EXISTS!!"
    exit -1
fi

cd $REPO_PATH && /usr/bin/git pull 

cd $SOURCE_CODE && $BUILD_EXE build  

cd $DEPLOY_FROM && ls| while read name
do
    echo "$DEPLOY_TO$name"
    rm -rf $DEPLOY_TO$name
done

cd $DEPLOY_FROM && ls| while read name
do
    echo "$name"
    mv "$name" "$DEPLOY_TO"
done


echo "DEPLOY SUCCESS!!"


