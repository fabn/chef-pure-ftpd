#
# Cookbook Name:: pure-ftpd
# Recipe:: firewall
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

# open the firewall port, data port and passive ports are handled by iptables module ip_conntrack_ftp
firewall_rule 'open incoming ftp port on firewall' do
  protocol :tcp
  port 21
  action :allow
  # Optionally restrict allowed sources
  source node[:pure_ftpd][:firewall_allow] if node[:pure_ftpd][:firewall_allow]
end
