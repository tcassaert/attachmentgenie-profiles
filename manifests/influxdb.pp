# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param manage_repo (Boolean) Manage repositories.
class profiles::influxdb (
  $manage_repo = false,
){
  class {'influxdb::server':
    graphite_options => {
      enabled           => true,
      database          => 'graphite',
      bind-address      => ':2003',
      protocol          => tcp,
      consistency-level => 'one',
      name-separator    => '.',
      batch-size        => 1000,
      batch-pending     => 5,
      batch-timeout     => '1s',
      udp-read-buffer   => 0,
      name-schema       => 'type.host.measurement.device',
      templates         => [ '*.app env.service.resource.measurement' ],
    },
    manage_repo      => $manage_repo,
  }
}
