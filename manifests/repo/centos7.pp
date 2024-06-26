# = Class: yum::repo::centos7
#
# Base Centos7 repos
#
# == Parameters:
#
# [*mirror_url*]
#   A clean URL to a mirror of `rsync://msync.centos.org::CentOS`.
#   The paramater is interpolated with the known directory structure to
#   create a the final baseurl parameter for each yumrepo so it must be
#   "clean", i.e., without a query string like `?key1=valA&key2=valB`.
#   Additionally, it may not contain a trailing slash.
#   Example: `http://mirror.example.com/pub/rpm/centos`
#   Default: `undef`
#
class yum::repo::centos7 (
  $mirror_url = undef,
  $setprio = true,
) {

  if $mirror_url {
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\/[\w~-]*)*$',
      '$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash.'
    )
  }

  $baseurl_base = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/\$releasever/os/\$basearch/",
  }

  $baseurl_updates = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/\$releasever/updates/\$basearch/",
  }

  $baseurl_extras = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/\$releasever/extras/\$basearch/",
  }

  $baseurl_centosplus = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/\$releasever/centosplus/\$basearch/",
  }

  if $setprio {
    $prio_2 = {
      failovermethod => 'priority',
      priority       => 2,
    }
    $prio_3 = {
      failovermethod => 'priority',
      priority       => 3,
    }
  } else {
    $prio_2 = {    }
    $prio_3 = {    }
  }

  yum::managed_yumrepo { 'base':
    descr          => 'CentOS-$releasever - Base',
    baseurl        => $baseurl_base,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    * => $prio_2
  }

  yum::managed_yumrepo { 'updates':
    descr          => 'CentOS-$releasever - Updates',
    baseurl        => $baseurl_updates,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    * => $prio_2
  }

  yum::managed_yumrepo { 'extras':
    descr          => 'CentOS-$releasever - Extras',
    baseurl        => $baseurl_extras,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    * => $prio_2
  }

  yum::managed_yumrepo { 'centosplus':
    descr          => 'CentOS-$releasever - Centosplus',
    baseurl        => $baseurl_centosplus,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    * => $prio_3
  }

}
