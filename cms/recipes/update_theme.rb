# to call include_recipe, we need following line
Chef::Log.debug("Running cms::update_theme.rb")
Chef::Log.debug(node.normal.to_json)

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

  # for each Git repository defined, pull
  repos = (cms[:repositories] rescue [])
  if(nil == repos)
    repos = []
  end

  repos.each do |repo|
    Chef::Log.debug("Pulling Git repository from remote")
    if((nil == repo[:branch]) || ("" == repo[:branch]))
      repo[:branch] = "master"
    end
    Chef::Log.debug(repo.to_json)

    # create directory
    Chef::Log.debug("Creating directory #{current_release}/#{repo[:path]}")
    directory "#{current_release}/#{repo[:path]}" do
      #group "deploy"
      #owner "nginx"
      mode 0755
      recursive true
      action :create
    end

    # try syncing theme from git
    git "#{current_release}/#{repo[:path]}" do
      repository repo[:repository]
      revision repo[:branch]
      action :sync
      ignore_failure true
    end

    # run clear cache script here
    # TODO: we should replace this with include_recipe
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
      notifies :reload, resources(:service => 'php-fpm'), :delayed
    end

  end

end
