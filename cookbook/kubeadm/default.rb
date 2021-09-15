remote_file "/etc/sysctl.d/k8s.conf"

execute "sysctl --system"

["iptables", "arptables", "ebtables"].each do |name|
  package name do
    action :install
  end
end

["update-alternatives --set iptables /usr/sbin/iptables-legacy", "update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy", "update-alternatives --set arptables /usr/sbin/arptables-legacy", "update-alternatives --set ebtables /usr/sbin/ebtables-legacy"].each do |command|
  execute command
end

# docker

["apt-transport-https", "ca-certificates", "curl", "gnupg", "lsb-release"].each do |name|
  package name do
    action :install
  end
end

execute "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"

remote_file "/etc/apt/sources.list.d/docker.list"

execute "apt-get update"

["docker-ce", "docker-ce-cli", "containerd.io"].each do |name|
    package name do
        action :install
    end
end

remote_file "/etc/docker/daemon.json"

directory "/etc/systemd/system/docker.service.d"

execute "systemctl daemon-reload"

service "docker" do
    action [:enable, :start]
end

# kubeadm, kubelet, kubectl

execute "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"

remote_file "/etc/apt/sources.list.d/kubernetes.list"

execute "apt-get update"

["kubelet", "kubeadm", "kubectl"].each do |name|
    package name do
        action :install
    end
end
