#
# Cookbook Name:: unattended_upgrades
# Recipe:: default
#
# Copyright 2012, Jeremiah Snapp
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

# reference: https://help.ubuntu.com/10.04/serverguide/C/automatic-updates.html
# unattended-upgrades log to /var/log/unattended-upgrades

# install a mailx package so unattended upgrades can email notifications
package "heirloom-mailx"

package "unattended-upgrades"

# set Unattended-Upgrade::Mail so email notifications will be sent when unattended upgrades run
template "/etc/apt/apt.conf.d/50unattended-upgrades" do
  source "50unattended-upgrades.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :unattended_upgrades_email => node[:unattended_upgrades][:email]
  )
end

# enable unattended upgrades
# you can read more about apt Periodic configuration options in the /etc/cron.daily/apt script header
# to test unattended-upgrades configuration just set APT::Periodic::RandomSleep to "0" and run /etc/cron.daily/apt
cookbook_file "/etc/apt/apt.conf.d/10periodic" do
  source "10periodic"
  owner  "root"
  group  "root"
  mode   "0644"
end
