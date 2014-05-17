service "nginx" do
  service_name "nginx"
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :restart ]
end