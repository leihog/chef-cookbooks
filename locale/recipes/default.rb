#
# Cookbook Name:: locale
# Recipe:: default
# Author:: Leif Högberg <leihog@gmail.com>
#
# No rights reserved - Do Redistribute
#

template "locale.gen" do

        path "/etc/locale.gen"
        source "locale.gen.erb"
        owner "root"
        group "root"
        mode 0644
        variables(
                :locales => node[:locale][:locales]
        )
        notifies :run, "execute[run-locale-gen]", :immediately

end

execute "run-locale-gen" do
  command "locale-gen"
  action :nothing
end