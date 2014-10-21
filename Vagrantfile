# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "GR360RY/trusty64-desktop-minimal"
  #config.vm.box = "package"
  #config.vm.box_url  = "file://package.box"

  # check if host platform is Linux, if not assume Windows
  linux_compatible = `ansible-playbook --version` rescue nil
  
  # if Linux host with Ansible installed, use native Ansible provisioning
  if(linux_compatible)
    print "...[INFO] Local Ansible installation detected - will attempt native Ansible provisioning \n"
    config.vm.provision "ansible" do |ansible|
     ansible.playbook = "server/devlocal.yml"
     ansible.groups = {
        "devlocal" => ["default"],
        "all_groups:children" => ["devlocal"]
     }
     ansible.raw_arguments = ['--private-key=ansible/ansible_key']
    end
  else # assume Windows (but could also be Linux without a local Ansible installation) and use shell bootstrap provisioning
    print "...[INFO] No local Ansible installation has been detected - defaulting to bootstrap provisioning \n"
    config.vm.provision :shell, :path => "vagrant/bootstrap.sh"
  end
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #config.vm.network "forwarded_port", guest: 22, host: 22222

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
     # Don't boot with headless mode
     vb.gui = true
     vb.customize ["modifyvm", :id, "--memory", "4096"]
     vb.customize ["modifyvm", :id, "--cpus", "2"]   
     vb.customize ["modifyvm", :id, "--monitorcount", "1"]
     vb.name = "Ubuntu Desktop"
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

end
