#
# Cookbook Name:: nginx-php
# Attributes:: nginxphp
#
# Copyright 2011, Aaron Abramson
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


case platform
when "debian","ubuntu"
  set[:nginx][:dir]     = "/etc/nginx"
  set[:nginx][:log_dir] = "/var/log/nginx"
  set[:nginx][:user]    = "www-data"
  set[:nginx][:group]   = "www-data"
  set[:nginx][:binary]  = "/usr/sbin/nginx"
else
  set[:nginx][:dir]     = "/etc/nginx"
  set[:nginx][:log_dir] = "/var/log/nginx"
  set[:nginx][:user]    = "www-data"
  set[:nginx][:group]   = "www-data"
  set[:nginx][:binary]  = "/usr/sbin/nginx"
end

default[:nginx][:web_root]  = "/www"


default[:nginx][:gzip] = "on"
default[:nginx][:gzip_http_version] = "1.0"
default[:nginx][:gzip_comp_level] = "2"
default[:nginx][:gzip_proxied] = "any"
default[:nginx][:gzip_types] = [
  "text/plain",
  "text/css",
  "application/x-javascript",
  "text/xml",
  "application/xml",
  "application/xml+rss",
  "text/javascript"
]

default[:nginx][:keepalive]          = "on"
default[:nginx][:keepalive_timeout]  = 65
default[:nginx][:worker_processes]   = cpu[:total]
default[:nginx][:worker_connections] = 2048
default[:nginx][:server_names_hash_bucket_size] = 64