#!/bin/bash

SOURCE_CODE="/home/deeper-think.github.io.ws/source_code"
DEPLOY_FROM="/home/deeper-think.github.io.ws/source_code/_site"
DEPLOY_TO="/usr/local/apache2/htdocs/"
BUILD_EXE="/usr/local/rvm/gems/ruby-2.0.0-p643/bin/jekyll"

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


