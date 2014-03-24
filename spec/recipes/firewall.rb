require 'spec_helper'

describe 'pure-ftpd::firewall' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:node) { chef_run.node }

  def execute_firewall_rule(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('firewall_rule', 'allow', resource_name)
  end

  it 'opens firewall port' do
    expect(chef_run).to execute_firewall_rule('open incoming ftp port on firewall').with(port: 21, protocol: :tcp)
  end

  context 'with custom params' do

    let(:trusted_source) { '10.0.0.0/8' }

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:pure_ftpd][:firewall_allow] = trusted_source
      end.converge(described_recipe)
    end

    it 'should allow host parametrization' do
      expect(chef_run).to execute_firewall_rule('open incoming ftp port on firewall').with(source: trusted_source)
    end

  end

end