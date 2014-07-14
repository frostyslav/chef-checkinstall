#
# Cookbook Name:: checkinstall
# Recipe:: default
# Author:: Rostyslav Fridman (<rostyslav.fridman@gmail.com>)
#
# Copyright 2014, Rostyslav Fridman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when "debian", "ubuntu"
  %w{make cmake gcc g++ checkinstall}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "redhat", "centos", "amazon", "scientific"
  %w{make cmake gcc gcc-c++ rpm-build rpmdevtools autoconf}.each do |pkg|
    package pkg do
      action :install
    end
  end
  remote_file "#{Chef::Config['file_cache_path']}/checkinstall.rpm" do
    source node['checkinstall']['url']
    action :create
  end
  rpm_package "checkinstall" do
    source "#{Chef::Config['file_cache_path']}/checkinstall.rpm"
    action :install
  end
  execute "create directory structure for RPM build" do
    command "rpmdev-setuptree"
    Chef::Log.info "Create directory structure for RPM build"
    not_if { ::File.directory?("/root/rpmbuild/SOURCES") }
  end
end
