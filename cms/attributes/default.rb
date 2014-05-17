default[:cms] = {}

default[:cms][:mysql] = {}
default[:cms][:mysql][:host] = "hebsmysqlproduction.cwpwch6sm7qc.us-east-1.rds.amazonaws.com"
default[:cms][:mysql][:username] = ""
default[:cms][:mysql][:password] = ""
default[:cms][:mysql][:database] = ""

default[:cms][:cache] = {}
default[:cms][:cache][:prefix] = "cms_opsworks"

default[:cms][:nginx][:customConfig] = ""
