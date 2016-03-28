require 'spec_helper'
require 'zenvelope'

describe Zenvelope do
  describe '.method_missing' do
    it 'creates instance of Zenvelope::Action class' do
      z = Zenvelope.new
      z.testaction
      expect(z.testaction).to be_instance_of(Zenvelope::Action)
    end
  end

  # FIXME: add zabbix 2.0 test env
  describe 'Zabbix 2.0' do
  end

  # FIXME: add zabbix 2.2 test env
  describe 'Zabbix 2.2' do
  end

  describe 'Zabbix 2.4' do
    before(:all) do
      @z24 = Zenvelope.new('https://zabbix24.testenv.org')
    end

    it 'logs in' do
      expect(@z24.login).to be_truthy
    end

    it 'gets api version' do
      expect(@z24.apiinfo.version).to match(/^2.4.\d+$/)
    end

    it 'queries "host.get" method' do
      expect(
        @z24.host.get(
          output: %w(hostid host),
          selectInterfaces: %w(interfaceid ip)
        )
      ).to eql(
        [
          {
            hostid: '10084',
            host: 'Zabbix server',
            interfaces: [
              {
                interfaceid: '1',
                ip: '127.0.0.1'
              }
            ]
          }
        ]
      )
    end
  end

  describe 'Zabbix 3.0' do
    before(:all) do
      @z30 = Zenvelope.new('https://zabbix30.testenv.org')
    end

    it 'logs in' do
      expect(@z30.login).to be_truthy
    end

    it 'gets api version' do
      expect(@z30.apiinfo.version).to match(/^3.0.\d+$/)
    end

    it 'queries "host.get" method' do
      expect(
        @z30.host.get(
          output: %w(hostid host),
          selectInterfaces: %w(interfaceid ip)
        )
      ).to eql(
        [
          {
            hostid: '10084',
            host: 'Zabbix server',
            interfaces: [
              {
                interfaceid: '1',
                ip: '127.0.0.1'
              }
            ]
          }
        ]
      )
    end
  end
end
