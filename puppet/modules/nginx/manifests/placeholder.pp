# == Class: nginx::placeholder
#
# TBD
#
# === Parameters
#
# [*hostname*]
#   TBD
#
# === Examples
#
#   nginx::placeholder { 'example.com': }
#
define nginx::placeholder (
  $hostname = $title
) {

  file { "/var/www/$hostname":
    ensure => directory,
  }

  file { "/var/www/$hostname/docroot":
    ensure => directory,
    require => File["/var/www/$hostname"],
  }

  file { "/var/www/$hostname/docroot/index.html":
    content => template('nginx/placeholder.html.erb'),
    require => File["/var/www/$hostname/docroot"],
  }

  file { "/etc/nginx/sites-available/$hostname":
    content => template('nginx/placeholder.conf.erb'),
    require => [Package['nginx'], File["/var/www/$hostname/docroot"]],
  }

  file { "/etc/nginx/sites-enabled/$hostname":
    ensure => link,
    target => "/etc/nginx/sites-available/$hostname",
    require => File["/etc/nginx/sites-available/$hostname"],
    notify => Service['nginx'],
  }

}
