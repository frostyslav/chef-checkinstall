#
# Cookbook Name:: checkinstall
# Attributes:: default
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

default['checkinstall']['url'] = "ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/andnagy/RedHat_RHEL-6/x86_64/checkinstall-1.6.2-20.2.x86_64.rpm"

default['checkinstall']['known_extensions'] = {
  ".tar.gz" => "tar zxf",
  ".tgz" => "tar zxf",
  ".tar.bz2" => "tar jxf",
  ".tar.xz" => "tar Jxf",
  ".tar.lz" => "tar --lzip xf",
  ".bz2" => "tar jf",
  ".gz" => "gunzip",
  ".zip" => "unzip"
}
