include_recipe 'deploy'

service 'redis' do
  supports :reload => false, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end
  
