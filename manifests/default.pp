# ===
# Install and Run Couchbase Server
# ===

$version = "2.1.1"
$filename = "couchbase-server-enterprise_x86_64_$version.deb"


# Update the resolv.conf
exec { "echo nameserver 8.8.8.8 > /etc/resolv.conf":
	path => "/bin"
}

# Download the Sources
exec { "couchbase-server-source":
    command => "/usr/bin/wget http://packages.couchbase.com/releases/$version/$filename",
    cwd => "/home/vagrant/",
    creates => "/home/vagrant/$filename",
    before => Package['couchbase-server']
}

# Update the System
exec { "apt-get update":
	path => "/usr/bin"
}

# Install libssl dependency
package { "libssl0.9.8":
	ensure => present,
	require => Exec["apt-get update"]
}

# Install Couchbase Server
package { "couchbase-server":
    provider => dpkg,
    ensure => installed,
    source => "/home/vagrant/$filename",
    require => Package["libssl0.9.8"]
}

# Ensure the service is running
service { "couchbase-server":
	ensure => "running",
	require => Package["couchbase-server"]
}