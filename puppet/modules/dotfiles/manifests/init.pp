# == Class: dotfiles
#
# This class installs the git-core package and a global gitconfig file.
#
# === Parameters
#
# [*username*]
#   TBD.
#
# === Examples
#
#   class { 'dotfiles':
#     username => 'johndoe', TODO: necessary?
#   }
#
class dotfiles($username = UNSET) {

  file { '/etc/profile.d/aliases.sh':
    source  => 'puppet:///modules/dotfiles/aliases.sh',
  }

}
