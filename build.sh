#!/usr/bin/env bash
shopt -s extglob

mkdir -p ./.deploy
cd .deploy

ls | grep -v -e vendor | xargs -r rm -fr
cp -r /var/task/!(vendor) /var/task/.deploy

yum -y install mysql-devel

bundle config set path "vendor/bundle"
bundle install

mkdir lib
cp -a /usr/lib64/mysql/*.so.* /var/task/.deploy/lib/

zip -qr ruby.zip lib script vendor .bundle
mv ruby.zip /var/task/ruby.zip
cd ..
rm -r ./.deploy
