node[:deploy].each do |application, deploy|
  
  Chef::Log.debug('Debugging configure.rb')
  Chef::Log.debug(application.to_json)
  Chef::Log.debug(deploy.to_json)
  
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end
  
  # create production .htaccess file
  template "#{deploy[:deploy_to]}/shared/config/.htaccess" do
    source "htaccess.erb"
    mode 0644
    group "deploy"
    owner "apache"
    variables(
      :env =>    (node[:server][:env] rescue 'production')
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
  
  shared_cms = "#{deploy[:deploy_to]}/shared/cms"

  # create proper shared CMS folder if does not exist
  directory shared_cms do
    group deploy[:group]
    owner deploy[:user]
    mode 0755
    action :create
    only_if do
      File.directory?("#{deploy[:deploy_to]}/shared")
    end
  end

  thedirs = [
    "#{shared_cms}/assets",
    "#{shared_cms}/cache",
    "#{shared_cms}/calendar",
    "#{shared_cms}/forms",
    "#{shared_cms}/imagepool",
    "#{shared_cms}/pressroom"
  ]
  
  thedirs.each do |the_dir|
    directory the_dir do
      group deploy[:group]
      owner deploy[:user]
      mode 0777
      action :create
      only_if do
        File.directory?("#{deploy[:deploy_to]}/shared/cms")
      end
    end
  end
  
  # create symlink to CMS
  link "#{deploy[:release_path]}/cms" do
    to "#{deploy[:deploy_to]}/shared/cms"
  end
  
  # create symlink to CMS folder
  link "#{deploy[:release_path]}/.htaccess" do
    to "#{deploy[:deploy_to]}/shared/config/.htaccess"
  end
  
end