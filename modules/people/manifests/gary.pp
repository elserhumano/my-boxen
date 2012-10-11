class people::gary {

  $my_username  = 'glarizza'
  $my_homedir   = "/Users/${my_username}"
  $my_sourcedir = "${my_homedir}/src"

  ############
  # Packages #
  ############

  package { 'Vagrant':
    ensure => installed,
    source => 'http://files.vagrantup.com/packages/be0bc66efc0c5919e92d8b79e973d9911f2a511f/Vagrant-1.0.5.dmg',
    provider => pkgdmg,
  }

  package { 'Virtualbox':
    ensure => installed,
    source => 'http://download.virtualbox.org/virtualbox/4.1.22/VirtualBox-4.1.23-80870-OSX.dmg',
    provider => pkgdmg,
  }

  package { 'tree':
    ensure => installed,
    provider => homebrew,
  }

  package { 'Dropbox':
    source   => 'https://ddr3luum8vl5r.cloudfront.net/Dropbox%201.4.3.dmg',
    provider => appdmg,
  }

  package { 'gawk': }
  package { 'zsh': }

  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
  }

  package { 'SizeUp':
    source   => 'http://www.irradiatedsoftware.com/download/SizeUp.zip',
    provider => compressed_app
  }

  package { 'Sparrow':
    source   => 'http://download.sparrowmailapp.com/appcast/Sparrow-latest.dmg',
    provider => appdmg,
  }

  package { 'Chrome':
    source   => 'http://dl.google.com/chrome/mac/stable/GoogleChrome.dmg',
    provider => appdmg,
  }

  File {
    owner  => $my_username,
    group  => 'staff',
  }


  ###############################
  # Git config and repositories #
  ###############################

  git::config::global{ 'user.name':
    value => 'Gary Larizza',
  }

  git::config::global{ 'user.email':
    value => 'gary@puppetlabs.com',
  }

  repository { "${my_sourcedir}/saleseng-demo-environment":
    source => 'puppetlabs/saleseng-demo-environment',
  }

  repository { "/Users/${my_username}/.vim":
    source => 'glarizza/vim-puppet'
  }

  repository { "${my_sourcedir}/oh-my-zsh":
    source  => 'glarizza/oh-my-zsh',
  }

  repository { "${my_sourcedir}/dotfiles":
    source => 'glarizza/dotfiles',
  }

  file { "/Users/${my_username}/.zshrc":
    ensure  => link,
    mode    => '0644',
    target  => "${my_sourcedir}/dotfiles/zshrc",
    require => Repository["${my_sourcedir}/dotfiles"],
  }

  file { "/Users/${my_username}/.oh-my-zsh":
    ensure  => link,
    target  => "${my_sourcedir}/oh-my-zsh",
    require => Repository["${my_sourcedir}/oh-my-zsh"],
  }


  ##################################
  ## Facter, Puppet, and Envpuppet##
  ##################################

  repository { "${my_sourcedir}/puppet":
    source => 'puppetlabs/puppet',
  }

  repository { "${my_sourcedir}/facter":
    source => 'puppetlabs/facter',
  }

  file { '/bin/envpuppet':
    ensure  => link,
    mode    => '0755',
    target  => "${my_sourcedir}/puppet/ext/envpuppet",
    require => Repository["${my_sourcedir}/puppet"],
  }
}
