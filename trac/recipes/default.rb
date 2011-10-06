#
# Cookbook Name:: trac
# Recipe:: default
# Author:: Leif Högberg <leihog@gmail.com>
#
# Copyleft 2011, Leif Högberg
#
# No rights reserved - Do Redistribute
#

include_recipe "python-setuptools"

bash "install trac from source" do
  not_if "which tracd > /dev/null"

  cwd "/usr/local/src"
  user "root"
  code <<-EOH
    wget http://ftp.edgewall.com/pub/trac/Trac-#{node[:trac][:version]}.tar.gz && \
    tar zxf Trac-#{node[:trac][:version]}.tar.gz && \
    cd Trac-#{node[:trac][:version]} && \
	python ./setup.py install
  EOH
end

template "trac.passwd" do
	not_if "test -f #{node[:trac][:parent_env]}/trac.passwd"

	path "#{node[:trac][:parent_env]}/trac.passwd"
	source "trac.passwd.erb"
	owner "root"
	group "root"
	mode 0775
	variables(
		:trac_default_user => node[:trac][:default_user]
	)
end

# fetch plugins

directory "#{node[:trac][:parent_env]}/.plugins/source" do
	owner "root"
	group "root"
	mode 0755
	action :create
	recursive true
end

bash "Downloading account plugin" do
	not_if "test -f #{node[:trac][:parent_env]}/.plugins/TracAccountManager-0.3.2-py2.6.egg"

	cwd "#{node[:trac][:parent_env]}/.plugins/source"
	user "root"
	code <<-EOH
		wget -O acctmngr.zip "http://trac-hacks.org/changeset/latest/accountmanagerplugin/0.11?old_path=/&filename=accountmanagerplugin/0.11&format=zip" && \
		unzip acctmngr.zip && \
		cd accountmanagerplugin/0.11 && \
		python ./setup.py bdist_egg && \
		mv ./dist/*.egg "#{node[:trac][:parent_env]}/.plugins"
	EOH
end

directory "#{node[:trac][:parent_env]}/.plugins/source" do
    action :delete
    recursive true
end

# end plugins

node[:trac][:projects].each do |project|

	unless File.exist?( "#{node[:trac][:parent_env]}/#{project}" )
	
		execute "trac-initenv" do
  			command "trac-admin #{node[:trac][:parent_env]}/#{project} initenv '#{project}' 'sqlite:db/trac.db'"
  			only_if "test ! -d #{node[:trac][:parent_env]}/#{project}"
		end

		template "trac-ini" do
			path "#{node[:trac][:parent_env]}/#{project}/conf/trac.ini"
			source "trac.ini.erb"
			owner "root"
			group "root"
			mode 0775
			variables(
				:trac_domain => node[:trac][:domain],
				:trac_project_name => project,
				:trac_project_desc => "Description for #{project}"
			)
		end
	
	end

end