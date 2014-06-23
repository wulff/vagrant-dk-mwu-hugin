# basic site manifest

# define global paths and file ownership
Exec { path => '/usr/sbin/:/sbin:/usr/bin:/bin' }
File { owner => 'root', group => 'root' }

# create a stage to make sure apt-get update is run before all other tasks
stage { 'requirements': before => Stage['main'] }
stage { 'bootstrap': before => Stage['requirements'] }

import 'settings'

class hugin::bootstrap {
  # we need an updated list of sources before we can apply the configuration
  exec { 'hugin_apt_update':
    command => '/usr/bin/apt-get update',
  }
}

class hugin::requirements {
  # install git-core and add some useful aliases
  class { 'git': }

  user { $user_name:
    ensure => present,
    managehome => true,
    comment => $user_comment,
    shell => '/bin/bash',
    groups => ['sudo'],
    password => $user_password,
  }

  ssh_authorized_key { $user_name:
    user => $user_name,
    ensure => present,
    type => 'ssh-rsa',
    key => $user_authorized_key,
    require => User[$user_name],
  }

  class { 'ssh':
    allowusers => $ssh_allowusers,
  }

  package { 'build-essential':
    ensure => present,
  }
}

class hugin::install {

  # configure the firewall

  class { 'iptables': }

  # configure postfix as a null client
  # http://www.postfix.org/STANDARD_CONFIGURATION_README.html#null_client

  class { 'postfix':
    hostname => 'hugin.mwu.dk',
  }

  # editors and site building tools

  package { 'vim':
    ensure => present,
  }
  exec { 'set-default-editor':
    command => 'update-alternatives --set editor /usr/bin/vim.basic',
    require => Package['vim'],
  }

  class { 'jekyll': }

  # monitoring and notification tools

  class { 'munin':
    user => $user_name,
    mail => $user_mail,
    hosts => [
      ['gere.mwu.dk', '192.168.187.17'],
      ['hugin.mwu.dk', '10.178.69.49'],
    ],
  }

  class { 'munin::node':
    # allow => 10.0.0.0, # IP of freke
    host => '10.178.69.49',
  }

  class { 'apticron':
    recipients => $apticron_recipients,
  }

  # web server and virtual hosts

  class { 'nginx':
    htpasswd => $htpasswd,
  }

  nginx::jekyll { 'psyke.org': }
  nginx::jekyll { 'ratatosk.net': }

  nginx::placeholder { 'ameliaberkeley.dk': }
  nginx::placeholder { 'egern.at': }
  nginx::placeholder { 'georgebuckley.dk': }
  nginx::placeholder { 'gracebuckley.dk': }
  nginx::placeholder { 'l10n.dk': }
  nginx::placeholder { 'laerdrupal.dk': }
  nginx::placeholder { 'mortenwulff.dk': }
  nginx::placeholder { 'mwu.dk': }
  nginx::placeholder { 'ratatosk.dk': }
  nginx::placeholder { 'tatosk.dk': }
  nginx::placeholder { 'thegoatfarm.dk': }
  nginx::placeholder { 'togliste.dk': }

  nginx::redirect { 'ameliaberkeley.com':
    destination => 'http://ameliaberkeley.dk/',
  }

  # install various system tools

  package { 'htop':
    ensure => present,
  }

  package { 'ncdu':
    ensure => present,
  }

  package { 'ntp':
    ensure => latest,
  }

  screen { $user_name:
    options => {
      'vbell' => 'on',
      'autodetach' => 'on',
      'startup_message' => 'off',
    },
    additions => [
      'screen -t local 0',
    ],
  }

  # update various system settings

  class { 'timezone':
    name => 'Europe/Copenhagen',
  }

  # various dot-files

  file { '/etc/profile.d/aliases.sh':
    content => 'alias update="sudo apt-get update"
alias upgrade="sudo apt-get upgrade"
alias puppet-apply="sudo puppet apply --modulepath=/home/wulff/vagrant/puppet/modules/ /home/wulff/vagrant/puppet/manifests/site.pp"',
    mode => 0644,
  }
}

class hugin::go {
  class { 'hugin::bootstrap':
    stage => 'bootstrap',
  }
  class { 'apt':
    stage => 'requirements',
  }
  class { 'hugin::requirements':
    stage => 'requirements',
  }
  class { 'hugin::install': }
}

include hugin::go
