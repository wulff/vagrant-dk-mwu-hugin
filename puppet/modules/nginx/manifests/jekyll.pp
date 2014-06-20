# == Class: nginx::jekyll
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
#   nginx::jekyll { 'example.com': }
#
define nginx::jekyll (
  $hostname = $title
) {

  file { "/var/www/$hostname":
    ensure => directory,
  }

  file { "/var/www/$hostname/docroot":
    ensure => directory,
    require => File["/var/www/$hostname"],
  }

  file { "/etc/nginx/sites-available/$hostname":
    content => template('nginx/jekyll.conf.erb'),
    require => [Package['nginx'], File["/var/www/$hostname/docroot"]],
  }

  file { "/etc/nginx/sites-enabled/$hostname":
    ensure => link,
    target => "/etc/nginx/sites-available/$hostname",
    require => File["/etc/nginx/sites-available/$hostname"],
    notify => Service['nginx'],
  }

}
