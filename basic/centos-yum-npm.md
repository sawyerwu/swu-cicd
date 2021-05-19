curl -sL https://rpm.nodesource.com/setup_14.x | bash -

yum -y install nodejs

node -v
npm -v

npm get registry
https://registry.npmjs.org/

npm config set registry http://registry.npm.taobao.org/

npm config set registry https://registry.npmjs.org/

npm install -g cnpm --registry=https://registry.npm.taobao.org


如果安装有问题，使用yum erase nodejs修复


https://my.oschina.net/u/4298883/blog/4437164