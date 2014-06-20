# == Class: jekyll
#
# This class installs and configures Jekyll and GSL.
#
# === Parameters:
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples#
#   class { 'munin':
#     version => latest,
#   }
#
class jekyll($version = present) {
  package { 'ruby-full':
    ensure => present,
  }

  package { 'ruby-gsl':
    ensure => present;
  }

  package { 'nodejs':
    ensure => present;
  }

  exec { 'gem-install-jekyll':
    command => 'gem install --no-rdoc --no-ri jekyll',
    creates => '/var/lib/gems/1.8/gems/jekyll-0.12.1/bin/jekyll',
    require => Package['ruby-full'];
  }
}
