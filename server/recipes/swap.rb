# create 1GB swap file if not already installed
bash "create_swapfile" do
  not_if do
    (0 == (node[:server][:swap] rescue 1)) || File.exists?("/swap/1GB.swap")
  end
  user "root"
  code <<-EOH
    sudo mkdir /swap
    sudo /bin/dd if=/dev/zero of=/swap/1GB.swap bs=1M count=1024
    sudo /sbin/mkswap /swap/1GB.swap
    sudo /sbin/swapon /swap/1GB.swap
    echo "/swap/1GB.swap swap swap defaults 0 0" | sudo tee -a /etc/fstab
  EOH
end