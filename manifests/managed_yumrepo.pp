# = Define yum::managed_yumrepo
#
define yum::managed_yumrepo (
  $descr           = 'absent',
  $baseurl         = 'absent',
  $mirrorlist      = 'absent',
  $enabled         = 0,
  $gpgcheck        = 0,
  $gpgkey          = 'absent',
  $gpgkey_source   = '',
  $gpgkey_name     = '',
  $failovermethod  = 'absent',
  $priority        = 99,
  $protect         = 'absent',
  $exclude         = 'absent',
  $autokeyimport   = 'no',
  $includepkgs     = 'absent',
  $metadata_expire = 'absent',
  $include         = 'absent',
  $sslcacert       = 'absent',
  $sslclientcert   = 'absent',
  $sslclientkey    = 'absent',
  $sslverify       = 'absent',
  $repo_gpgcheck   = 'absent',
  $module_hotfixes = 'absent',
  ) {

  # ensure that everything is setup
  include ::yum::prerequisites

  if $protect != 'absent' {
    if ! defined(Yum::Plugin['protectbase']) {
      yum::plugin { 'protectbase': }
    }
  }

  if ! defined(File["/etc/yum.repos.d/${name}.repo"]) {
    file { "/etc/yum.repos.d/${name}.repo":
      ensure  => file,
      replace => false,
      before  => Yumrepo[ $name ],
      mode    => '0644',
      owner   => 'root',
      group   => 0,
    }

    $gpgkey_real_name = $gpgkey_name ? {
      ''      => url_parse($gpgkey_source,'filename'),
      default => $gpgkey_name,
    }

    if $gpgkey_source != '' {
      if ! defined(File["/etc/pki/rpm-gpg/${gpgkey_real_name}"]) {
        file { "/etc/pki/rpm-gpg/${gpgkey_real_name}":
          ensure  => file,
          replace => false,
          before  => Yumrepo[ $name ],
          source  => $gpgkey_source,
          mode    => '0644',
          owner   => 'root',
          group   => 0,
        }
      }
    }
  }

  if ! defined(Yumrepo[$name]) {
    yumrepo { $name:
      descr           => $descr,
      baseurl         => $baseurl,
      mirrorlist      => $mirrorlist,
      enabled         => $enabled,
      gpgcheck        => $gpgcheck,
      gpgkey          => $gpgkey,
      failovermethod  => $failovermethod,
      priority        => $priority,
      protect         => $protect,
      exclude         => $exclude,
      includepkgs     => $includepkgs,
      metadata_expire => $metadata_expire,
      include         => $include,
      sslcacert       => $sslcacert,
      sslclientcert   => $sslclientcert,
      sslclientkey    => $sslclientkey,
      sslverify       => $sslverify,
      repo_gpgcheck   => $repo_gpgcheck,
      module_hotfixes => $module_hotfixes,
    }

    if $autokeyimport == 'yes' and $gpgkey != '' {
      exec { "rpmkey_add_${gpgkey}":
        command     => "rpm --import ${gpgkey}",
        before      => Yumrepo[ $name ],
        refreshonly => true,
        path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      }
    }
  }
}
