require 'spec_helper'

describe 'pure-ftpd::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs pure-ftpd package' do
    expect(chef_run).to install_package('pure-ftpd')
  end

  it 'install a fixed template for /etc/default/pure-ftpd-common' do
    expect(chef_run).to render_file('/etc/default/pure-ftpd-common').with_content('STANDALONE_OR_INETD=standalone')
  end

  describe 'Service' do
    it 'enable the service' do
      expect(chef_run).to enable_service('pure-ftpd')
    end

    it 'restart the service' do
      expect(chef_run).to restart_service('pure-ftpd')
    end
  end

  describe 'Daemon configuration' do

    it 'should configure using files in /etc/pure-ftpd/conf/' do
      chef_run.node[:pure_ftpd][:options].each do |option, value|
        expect(chef_run).to create_file("/etc/pure-ftpd/conf/#{option}").with_content(value)
      end
    end

    # This is used when one wants to override some default values
    it 'should skip options overridden with nil' do
      chef_run = ChefSpec::Runner.new do |node|
        # override umask default given in attributes
        node.override[:pure_ftpd][:options][:Umask] = false
      end.converge(described_recipe)
      # File should not be created since attribute is overriden with falsey value
      expect(chef_run).to_not create_file('/etc/pure-ftpd/conf/Umask')
    end

  end

  describe 'Authentication with virtual users' do

    let(:user) do
      {login: 'ftpuser', password: 'secret', home: '/home/ftp',
       system_user: 'ftp', system_group: 'ftp'}
    end

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:pure_ftpd][:users] = [user]
      end.converge(described_recipe)
    end

    it 'recreate virtual users database' do
      expect(chef_run).to delete_file('/etc/pure-ftpd/pureftpd.passwd')
      expect(chef_run).to delete_file('/etc/pure-ftpd/pureftpd.pdb')
    end

    it 'create users according to node[:pure_ftpd][:users] array' do
      user_create_command = %Q{(echo #{user[:password]}; echo #{user[:password]}) | pure-pw useradd #{user[:login]} -u #{user[:system_user]} -g #{user[:system_group]} -d #{user[:home]}}
      expect(chef_run).to run_execute(user_create_command)
    end

    it 'recreate password database' do
      expect(chef_run).to run_execute('pure-pw mkdb')
    end

    it 'remove the existing auth methods' do
      expect(chef_run).to run_execute('find /etc/pure-ftpd/auth -type l | xargs rm')
    end

    it 'link the authentication method with internal user db' do
      expect(chef_run).to create_link('/etc/pure-ftpd/auth/50pure').with(to: '../conf/PureDB')
    end

  end


end