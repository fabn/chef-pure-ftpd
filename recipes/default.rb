#
# Cookbook Name:: pure-ftpd
# Recipe:: default
#
# Copyright (C) 2014 Fabio Napoleoni
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install the package
package 'pure-ftpd'

# Enable the service
service 'pure-ftpd' do
  action :enable
end

# Enable chrooting using template
cookbook_file '/etc/default/pure-ftpd-common' do
  source 'pure-ftpd-common'
  mode '0644'
end

# Empty current virtual users database
%w(pureftpd.passwd pureftpd.pdb).each do |user_db|
  file("/etc/pure-ftpd/#{user_db}") { action :delete }
end

# Recreate users database
node[:pure_ftpd][:users].each do |user|
  # create the needed user
  execute "create ftp user #{user[:login]}" do
    command %Q{(echo #{user[:password]}; echo #{user[:password]}) | pure-pw useradd #{user[:login]} -u #{user[:system_user]} -g #{user[:system_group]} -d #{user[:home]}}
  end
end

# commit changes
execute 'commit user db changes' do
  command 'pure-pw mkdb'
end

# pure ftp auth configuration
execute 'remove all existing auth methods' do
  command 'find /etc/pure-ftpd/auth -type l | xargs rm'
end

# Enable virtual users
link '/etc/pure-ftpd/auth/50pure' do
  to '../conf/PureDB'
end

# Delete all builtin configuration directives, see man pure-ftpd-wrapper
execute 'remove all existing configuration options' do
  command 'find /etc/pure-ftpd/conf -type f | xargs rm'
end

# Configure options
node[:pure_ftpd][:options].reject { |_, v| !v }.each do |option, value|
  file "/etc/pure-ftpd/conf/#{option}" do
    content value
    mode '0644'
  end
end

# Restart the server after configuration
service 'pure-ftpd' do
  action :restart
end
