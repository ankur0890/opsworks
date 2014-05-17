node[:deploy].each do |application, deploy|
  
  Chef::Log.debug('Debugging cms::config.rb')
  Chef::Log.debug(application.to_json)
  Chef::Log.debug(deploy.to_json)
  
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end
  
  shared_cms = "#{deploy[:deploy_to]}/shared/cms"

  # create proper shared CMS folder if does not exist
  directory shared_cms do
    #group "deploy"
    #owner "nginx"
    mode 0775
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
    "#{shared_cms}/poi",
    "#{shared_cms}/imagepool",
    "#{shared_cms}/pressroom"
  ]
  
  thedirs.each do |the_dir|
    directory the_dir do
      #group "deploy"
      #owner "nginx"
      mode 0777
      action :create
      only_if do
        File.directory?("#{deploy[:deploy_to]}/shared/cms")
      end
    end
  end
  
  # create symlink to CMS
  link "#{deploy[:release_path]}/cms" do
    #group "deploy"
    #owner "nginx"
    to "#{deploy[:deploy_to]}/shared/cms"
  end
  
end