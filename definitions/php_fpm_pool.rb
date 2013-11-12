#
# Cookbook Name:: php-fpm
# Definition:: php_fpm_pool
#
# Copyright 2008-2009, Opscode, Inc.
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

define :php_fpm_pool, :template => "pool.conf.erb", :enable => true do

  pool_name = params[:name]

  include_recipe "php-fpm"

  conf_file = "#{node['php-fpm']['conf_dir']}/pools/#{pool_name}.conf"

  if params[:enable]
    template conf_file do
      only_if "test -d #{node['php-fpm']['conf_dir']}/pools || mkdir -p #{node['php-fpm']['conf_dir']}/pools"
      source params[:template]
      owner "root"
      group "root"
      mode 00644
      cookbook params[:cookbook] || "php-fpm"
      variables(
        :pool_name => pool_name,
        :listen => params[:listen],
        :allowed_clients => params[:allowed_clients],
        :user => params[:user],
        :group => params[:group],
        :process_manager => params[:process_manager],
        :max_children => params[:max_children],
        :start_servers => params[:start_servers],
        :min_spare_servers => params[:min_spare_servers],
        :max_spare_servers => params[:max_spare_servers],
        :max_requests => params[:max_requests],
        :catch_workers_output => params[:catch_workers_output],
        :params => params
      )
      notifies :enable, "service[php-fpm]"
      notifies :restart, "service[php-fpm]"
    end
  else
    cookbook_file conf_file do
      action :delete
      notifies :restart, "service[php-fpm]"
    end
  end
end
