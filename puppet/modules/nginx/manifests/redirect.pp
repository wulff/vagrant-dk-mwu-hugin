# == Class: nginx::redirect
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
#   nginx::redirect { 'example.com': }
#
define nginx::redirect (
  $hostname = $title,
  $destination = UNSET
) {

  file { "/var/www/$hostname":
    ensure => directory,
  }

  file { "/etc/nginx/sites-available/$hostname":
    content => template('nginx/redirect.conf.erb'),
    require => Package['nginx'],
  }

  file { "/etc/nginx/sites-enabled/$hostname":
    ensure => link,
    target => "/etc/nginx/sites-available/$hostname",
    require => File["/etc/nginx/sites-available/$hostname"],
    notify => Service['nginx'],
  }

}
