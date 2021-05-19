wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum localinstall mysql57-community-release-el7-11.noarch.rpm -y

yum repolist enabled | grep "mysql.*-community.*"
yum install -y mysql-community-server

systemctl start mysqld
systemctl status mysqld
systemctl enable mysqld


grep 'temporary password' /var/log/mysqld.log
mysql -uroot -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!'; 

set global validate_password_policy=0;
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'admin123' WITH GRANT OPTION;

vim /etc/my.cnf
[mysqld]
character-set-server=utf8
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8


systemctl restart mysqld
mysql -uroot -p



https://www.cnblogs.com/ivictor/p/5142809.html  
https://www.jianshu.com/p/1dab9a4d0d5f
