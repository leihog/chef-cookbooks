# Cookbook Name:: trac
# Attribute :: trac
#
# Copyleft 2011 Leif Högberg <leihog@gmail.com>
#
default[:trac] = {}
default[:trac][:version] = "0.12.2"
default[:trac][:major_version] = "0.12"
default[:trac][:parent_env] = "/media/sf_projects/trac"
default[:trac][:default_user] = "test"
default[:trac][:passwd_file] = "#{default[:trac][:parent_env]}/trac.passwd"
default[:trac][:domain] = "trac.local"
default[:trac][:projects] = ["odin", "thor"]