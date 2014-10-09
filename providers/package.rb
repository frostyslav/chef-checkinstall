#
# Cookbook Name:: checkinstall
# Provider:: package
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

def whyrun_supported?
  true
end

use_inline_resources

action :package do

  raise "You should specify source_archive or source_dir attribute" if not new_resource.source_archive and not new_resource.source_dir
  raise "You should specify either source_archive or source_dir attribute" if new_resource.source_archive and new_resource.source_dir

  if should_be_installed?
    if new_resource.source_archive
      raise "Can't find source archive #{new_resource.source_archive}" if not ::File.exists?(new_resource.source_archive)
      archive_types = node['checkinstall']['known_extensions']

      extension = get_extension(archive_types)

      source_dir = new_resource.source_archive.gsub(extension,"")

      cmd_extract = how_to_extract?(extension, archive_types)

      execute "extract #{new_resource.source_archive}" do
        cwd Chef::Config['file_cache_path']
        command "#{cmd_extract} #{new_resource.source_archive}"
        Chef::Log.info "Extract #{new_resource.source_archive}"
        new_resource.updated_by_last_action(true)
      end
    else
      raise "Can't find directory #{new_resource.source_dir}" if not ::File.directory?(new_resource.source_dir)
      source_dir = new_resource.source_dir
    end

    execute "autoheader #{new_resource.package_name}" do
      cwd source_dir
      command "autoheader"
      Chef::Log.info "Autoheader #{new_resource.package_name}"
      new_resource.updated_by_last_action(true)
      only_if { new_resource.autoheader }
    end

    execute "autoconf #{new_resource.package_name}" do
      cwd source_dir
      command "autoconf"
      Chef::Log.info "Autoconf #{new_resource.package_name}"
      new_resource.updated_by_last_action(true)
      only_if { new_resource.autoconf }
    end

    if new_resource.configure_options.kind_of?(Array)
      configure_options = new_resource.configure_options.join(' ')
    else
      configure_options = new_resource.configure_options
    end

    if new_resource.make_options.kind_of?(Array)
      make_options = new_resource.make_options.join(' ')
    else
      make_options = new_resource.make_options
    end

    execute "configure #{new_resource.package_name} with cmake" do
      cwd source_dir
      command "cmake #{configure_options}"
      Chef::Log.info "Configure #{new_resource.package_name} with cmake"
      new_resource.updated_by_last_action(true)
      only_if { new_resource.cmake }
    end

    execute "configure #{new_resource.package_name}" do
      cwd source_dir
      command "./configure #{configure_options}"
      Chef::Log.info "Configure #{new_resource.package_name}"
      new_resource.updated_by_last_action(true)
      only_if { new_resource.configure }
    end

    execute "compile #{new_resource.package_name}" do
      cwd source_dir
      command "make #{make_options}"
      Chef::Log.info "Compile #{new_resource.package_name}"
      new_resource.updated_by_last_action(true)
      only_if { new_resource.make }
    end

    case node['platform']
      when "debian", "ubuntu"
        checkinstall_options = "-y --pkgname=#{new_resource.package_name}"
      when "redhat", "centos", "amazon", "scientific"
        checkinstall_options = "-R -y --install=yes --fstrans=no --pkgname=#{new_resource.package_name}"
    end

    checkinstall_options += " --pkgversion=#{new_resource.version}" if new_resource.version
    checkinstall_options += " #{new_resource.options}" if new_resource.options

    execute "install #{new_resource.package_name}" do
      cwd source_dir
      command "checkinstall #{checkinstall_options}"
      Chef::Log.info "Install #{new_resource.package_name}"
      new_resource.updated_by_last_action(true)
      only_if { new_resource.checkinstall }
    end

  end
end

def get_extension(archive_types)
  archive_types.keys.any? do |extension|
    if new_resource.source_archive.include?(extension)
      return extension
    end
  end
end

def how_to_extract?(extension, archive_types)
  archive_types[extension]
end

def should_be_installed?()

  if new_resource.binary_location
    binary_location = new_resource.binary_location
  else
    name = new_resource.binary_name ? new_resource.binary_name : new_resource.package_name
    cmd_check = Mixlib::ShellOut.new("which #{name} 2>/dev/null")
    cmd_check.run_command
    binary_location = cmd_check.stdout.chomp
  end

  if ::File.exists?(binary_location)
    if new_resource.version
      case node['platform']
        when "debian", "ubuntu"
          version_check_command = "dpkg-query --show --showformat='${Version}' #{new_resource.package_name}"
        when "redhat", "centos", "amazon", "scientific"
          version_check_command = "rpm --query --all --queryformat \"%{VERSION}\" #{new_resource.package_name}"
      end
      cmd = Mixlib::ShellOut.new(version_check_command)
      cmd.run_command
      if cmd.stdout != ""
        # Debian systems can set version in format 1:0.1.2
        # that is why we can't use /[0-9\.]+/ regex
        current_version = cmd.stdout.match(/[0-9]\.[0-9\.]+/)
        new_version = new_resource.version.match(/[0-9]\.[0-9\.]+/)
        Gem::Version.new(new_version) > Gem::Version.new(current_version)
      else
        true
      end
    end
  else
    true
  end
end
