require 'spec_helper'
describe 'profiles::collectd' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          collectd_version: '5.5.0',
        })
      end
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::collectd') }
      end
    end
  end
end
