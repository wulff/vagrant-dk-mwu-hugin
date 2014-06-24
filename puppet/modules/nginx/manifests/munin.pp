# == Class: nginx::munin
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
#   nginx::munin { 'example.com': }
#
define nginx::munin (
  $hostname = $title
) {

  file { "/etc/nginx/sites-available/$hostname":
    content => template('nginx/munin.conf.erb'),
    require => [Package['nginx'], Package['munin']],
  }

  file { "/etc/nginx/sites-enabled/$hostname":
    ensure => link,
    target => "/etc/nginx/sites-available/$hostname",
    require => File["/etc/nginx/sites-available/$hostname"],
    notify => Service['nginx'],
  }

}
