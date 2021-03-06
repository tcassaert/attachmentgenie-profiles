# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
# @param checks       Consul checks,
# @param config       Consul config,
# @param domain       Resolv.conf domain
# @param options      Additional consul start up flags.
# @param searchpath   Resolv.conf searchpath.
# @param server       Run as Server.
# @param services     Consul services.
# @param version      Version of consul to install.
# @param watches      Consul watches.
# @param ui           Enable UI.
class profiles::orchestration::consul (
  Hash $checks = {},
  Hash $config = {},
  Hash $config_defaults = {
    'data_dir'   => '/var/lib/consul',
    'datacenter' => 'vagrant',
  },
  Stdlib::Absolutepath $config_dir = '/etc/consul.d',
  String $options = '-enable-script-checks -syslog',
  Boolean $server = false,
  Hash $services = {},
  String $version = '1.5.2',
  Boolean $ui = false,
  Hash $watches = {},
) {
  if ! defined(Package['unzip']) {
    package { 'unzip':
      ensure => present,
    }
  }
  -> class { '::consul':
    config_defaults => $config_defaults,
    config_dir      => $config_dir,
    config_hash     => $config,
    extra_options   => $options,
    version         => $version,
  }

  if $server {
    profiles::bootstrap::firewall::entry { '100 allow consul rpc':
      port => 8300,
    }
    profiles::bootstrap::firewall::entry { '100 allow consul serf WAN':
      port => 8302,
    }
  }
  if $ui {
    profiles::bootstrap::firewall::entry { '100 allow consul ui':
      port => 8500,
    }
  }
  profiles::bootstrap::firewall::entry { '100 allow consul serf LAN':
    port => 8301,
  }
  profiles::bootstrap::firewall::entry { '100 allow consul DNS TCP':
    port     => 8600,
    protocol => 'tcp'
  }
  profiles::bootstrap::firewall::entry { '100 allow consul DNS UDP':
    port     => 8600,
    protocol => 'udp',
  }

  create_resources(::consul::check, $checks)
  create_resources(::consul::service, $services)
  create_resources(::consul::watch, $watches)
}
