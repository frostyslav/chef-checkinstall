#
# Cookbook Name:: checkinstall
# Resource:: package
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

actions :package

default_action :package

attribute :package_name, :name_attribute => true, :kind_of => String
attribute :source_archive, :kind_of => [String, NilClass], :regex => /.*/, :default => nil
attribute :source_dir, :kind_of => [String, NilClass], :regex => /.*/, :default => nil
attribute :version, :kind_of => [String, NilClass], :regex => /.*/, :default => nil
attribute :options, :kind_of => [String, NilClass], :regex => /.*/, :default => nil
attribute :configure_options, :kind_of => [String, Array], :regex => /.*/, :default => ""
attribute :binary_name, :kind_of => [String, NilClass], :regex => /.*/, :default => nil
attribute :binary_location, :kind_of => [String, NilClass], :regex => /.*/, :default => nil
attribute :autoheader, :kind_of => [TrueClass, FalseClass], :default => false
attribute :autoconf, :kind_of => [TrueClass, FalseClass], :default => false
attribute :configure, :kind_of => [TrueClass, FalseClass], :default => true
attribute :make, :kind_of => [TrueClass, FalseClass], :default => true
attribute :make_options, :kind_of => [String, NilClass], :regex => /.*/, :default => ""
attribute :checkinstall, :kind_of => [TrueClass, FalseClass], :default => true
attribute :cmake, :kind_of => [TrueClass, FalseClass], :default => false
