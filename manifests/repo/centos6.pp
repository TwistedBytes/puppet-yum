# = Class: yum::repo::centos6
#
# Base Centos6 repos
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
class yum::repo::centos6 (
  $mirror_url = undef,
) {

  if $mirror_url {
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\:[0-9]{1,5})?(?:\/[\w~-]*)*$',
      '$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash.'
    )
  }

  $baseurl_base = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/6.10/os/\$basearch/",
  }

  $baseurl_updates = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/6.10/updates/\$basearch/",
  }

  $baseurl_extras = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/6.10/extras/\$basearch/",
  }

  $baseurl_centosplus = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/6.10/centosplus/\$basearch/",
  }

  $baseurl_contrib = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/6.10/contrib/\$basearch/",
  }

  yum::managed_yumrepo { 'base':
    descr          => 'CentOS-$releasever - Base',
    baseurl        => $baseurl_base,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os',
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 2,
  }

  yum::managed_yumrepo { 'updates':
    descr          => 'CentOS-$releasever - Updates',
    baseurl        => $baseurl_updates,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates',
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 2,
  }

  yum::managed_yumrepo { 'extras':
    descr          => 'CentOS-$releasever - Extras',
    baseurl        => $baseurl_extras,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras',
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 2,
  }

  yum::managed_yumrepo { 'centosplus':
    descr          => 'CentOS-$releasever - Centosplus',
    baseurl        => $baseurl_centosplus,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus',
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 3,
  }

  yum::managed_yumrepo { 'contrib':
    descr          => 'CentOS-$releasever - Contrib',
    baseurl        => $baseurl_contrib,
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib',
    failovermethod => 'priority',
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 10,
  }

}
