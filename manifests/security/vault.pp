# This class can be used install vault components.
#
# @example when declaring the vault class
#  class { '::profiles::security::vault': }
#
class profiles::security::vault (
  $config_dir = '/etc/vault.d',
  $enable_ui = true,
  Variant[Hash, Array[Hash]] $listener = {
    'tcp' => {
      'address'         => '127.0.0.1:8200',
      'cluster_address' => '127.0.0.1:8201',
      'tls_disable'     => 1,
    },
  },
  Hash $extra_config = { 'api_addr' => 'https://127.0.0.1:8200', 'cluster_addr' => 'https://127.0.0.1:8201' },
  Boolean $manage_storage_dir = true,
  Hash $storage = { 'consul' => { 'address' => '127.0.0.1:8500', 'path' => 'vault/' }},
  String $version = '1.1.3',
){
  class {'vault':
    config_dir         => $config_dir,
    enable_ui          => $enable_ui,
    extra_config       => $extra_config,
    listener           => $listener,
    manage_storage_dir => $manage_storage_dir,
    storage            => $storage,
    version            => $version,
  }

  profiles::bootstrap::firewall::entry { '200 allow vault UI and API':
    port => [8200],
  }
  profiles::bootstrap::firewall::entry { '200 allow vault cluster':
    port => [8201],
  }
}