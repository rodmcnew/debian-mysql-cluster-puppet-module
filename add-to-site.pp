node mysql-cluster inherits all-servers {

    #mysql depends on this package
    package { 'libaio1':}

    -> group { 'mysql':
      ensure => 'present',
      gid    => '1002',
    }
 
    -> user { 'mysql':
      ensure           => 'present',
      gid              => '1002',
      home             => '/home/mysql',
      password         => '!',
      password_max_age => '-1',
      password_min_age => '-1',
      shell            => '/bin/sh',
      uid              => '999',
    }

    -> file { '/etc/my.cnf':
        ensure  => 'file',
        source => "puppet:///modules/mysql-cluster/mysql-cluster-my.cnf",
        group   => '0',
        mode    => '644',
        owner   => '0',
    } 

    -> file {"/usr/local/mysql-cluster-gpl-7.2.7-linux2.6-x86_64.tar.gz":
      source => "puppet:///modules/mysql-cluster/mysql-cluster-tar/mysql-cluster-gpl-7.2.7-linux2.6-x86_64.tar.gz",
      ensure => file,
        group  => '0',
        owner  => '0',
        mode   => '644',
    }

    -> file {"/usr/local/mysql-cluster-install.sh":
          source => "puppet:///modules/mysql-cluster/mysql-cluster/mysql-cluster-install.sh",
          ensure => file,
            group  => '0',
            owner  => '0',
            mode   => '755',
    }

    -> exec { "untar mysql cluster":
        command => "/bin/tar zxvf /usr/local/mysql-cluster-gpl-7.2.7-linux2.6-x86_64.tar.gz -C /usr/local",
        creates => "/usr/local/mysql-cluster-gpl-7.2.7-linux2.6-x86_64",
    }

    -> file { '/usr/local/mysql':
       ensure => 'link',
       target => '/usr/local/mysql-cluster-gpl-7.2.7-linux2.6-x86_64',
    }

    -> exec { "cp /etc/init.d/mysql.server":
        command => "/bin/cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql.server",
        creates => "/etc/init.d/mysql.server",
    }

    -> exec { "mysql-cluster-install.sh":
        command => "/usr/local/mysql-cluster-install.sh > /dev/null",
        creates => "/usr/local/mysql/mysql.cluster.install.sh.has-ran",
    }   
}

node /^dbdata/ inherits mysql-cluster {

}

node /^dbapi/ inherits mysql-cluster {
    
}

node /^dbmgr/ inherits mysql-cluster {
    
    file { '/etc/mysql-cluster-config.ini':
        ensure  => 'file',
        source => "puppet:///modules/mysql-cluster/mysql-cluster/mysql-cluster-config.ini",
        group   => '0',
        mode    => '644',
        owner   => '0',
    }
}
