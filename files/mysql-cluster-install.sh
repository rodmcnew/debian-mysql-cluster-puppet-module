cd /usr/local/mysql
chown -R mysql .
chgrp -R mysql .
scripts/mysql_install_db --user=mysql
chown -R root .
chown -R mysql data
# Next command is optional
#cp support-files/my-medium.cnf /etc/my.cnf
#bin/mysqld_safe --user=mysql & #this should only run on api nodes
# Next command is optional
touch /usr/local/mysql/mysql.cluster.install.sh.has-ran

