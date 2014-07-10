checkinstall Cookbook
==============
This cookbook installs checkinstall software

Requirements
------------
### Supported Operating Systems
- Debian-family Linux Distributions
- RedHat-family Linux Distributions

Attributes
----------
### Recommended tunables

* `checkinstall['url']`
  - String. Points to the checkinstall source codes archive location

Usage
-----
Include the recipe `checkinstall` somewhere in your run list, then use the LWRPs `checkinstall_package` in your recipes.

`checkinstall_package` Resource
-------------------------------

Defines wrapper for configure/make/checkinstall chain of commands.
Example (with full attributes list):

    checkinstall_package "strongswan" do
      source_archive "/var/chef/cache/strongswan-5.1.3.tar.bz2"
      #source_dir "/var/chef/cache/strongswan-5.1.3"
      configure_options "--enable-xauth-eap --enable-eap-tls --enable-eap-radius"
      version "5.1.3"
      binary_name "ipsec"
      #options "-y"
      #binary_location "/usr/local/sbin/ipsec"
      #cmake false
      #autoconf false
      #autoheader false
      #make true
      #configure true
      #checkinstall true
    end

Requires `source_archive` OR `source_dir` attribute, other attributes are optional.
* `source_archive`
  - Defaults to `nil`
  - One of the required attributes
* `source_dir`
  - Defaults to `nil`
  - One of the required attributes
* `version`
  - Defaults to `nil`
  - Necessary if you want to support software updates
* `binary_name`
  - Defaults to `nil`
  - Necessary when package name is different from the binary name
* `binary_location`
  - Defaults to `nil`
  - Should be used when the binary location is not in the system $PATH
* `autoheader`
  - Defaults to `false`
  - Should be used when package is configured with autoheader command
* `autoconf`
  - Defaults to `false`
  - Should be used when package is configured with autoheader command
* `cmake`
  - Defaults to `false`
  - Should be used when package is configured with cmake instead of ./configure
* `options`
  - Defaults to `""`
  - Should be used when adding some additional options to checkinstall
* `configure`
  - Defaults to `true`
  - Should be set to `false`, when cmake should be used
* `make`
  - Defaults to `true`
  - Should be set to `false`, when there is no need to compile the software
* `checkinstall`
  - Defaults to `true`
  - Should be set to `false`, when there is no need to install the software

License and Authors
-------------------

- Author:: Rostyslav Fridman (rostyslav.fridman@gmail.com)

```text
Copyright 2014, Rostyslav Fridman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
