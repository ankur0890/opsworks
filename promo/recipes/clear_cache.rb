Chef::Log.debug("Running cms::clear_cache.rb")
Chef::Log.debug(node.normal.to_json)

Chef::Log.debug("node.normal[:opsworks]")
Chef::Log.debug(node.normal[:opsworks].to_json)

Chef::Log.debug("node.normal[:opsworks][:applications]")
Chef::Log.debug(node.normal[:opsworks][:applications].to_json)

# initialize php-fpm service reference to be triggered later
service 'php-fpm' do
  supports :status => true, :restart => true, :reload => true
end

# Loop through the applications
node.normal[:opsworks][:applications].each do |app|
  
	if app[:application_type] != 'php'
		Chef::Log.debug("Skipping cms::clear_cache application #{app[:name]} as it is not a PHP app")
		next
	end

	# cms options
	cms = node.normal[:cms]

	Chef::Log.debug("Current release path")
	current_release = "/srv/www/#{app[:slug_name]}/current"
	Chef::Log.debug(current_release)

	# run clear cache script here
	script "run_cms_clear_cache" do
		interpreter "bash"
		user "root"
		cwd current_release

		code <<-EOH
		php core/data/upgrade.php
		EOH
		only_if do
			::File.exists?("#{current_release}/core/data/upgrade.php")
		end
		# delayed restart php-fpm after running upgrade to clear apc (executed at the very end of a chef-client run)
		notifies :restart, resources(:service => 'php-fpm'), :delayed
	end

end