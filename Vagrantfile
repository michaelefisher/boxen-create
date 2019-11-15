# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

VAGRANT_COMMAND = ARGV[0]

system("
  if [ #{ARGV[0]} = 'up' ] || [ #{ARGV[0]} = 'provision' ]; then
    echo 'Running `vagrant up` or `vagrant provision`, so first creating data directory and linking files'
    if [ ! -d '$HOME/data' ]; then
    	mkdir -p $HOME/data
    fi
    # Always copy to get a fresh playbook
   	cp -f provision_vm.yml $HOME/data/provision_vm.yml
  fi
")

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/ubuntu-16.04"

  # Hostname
  config.vm.hostname = "gonzo-the-great"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "/Users/michael/data", "/vagrant_data"

  # ssh settings

  config.ssh.insert_key = false
  config.ssh.private_key_path = ["/Users/michael/.ssh/michaelfisher", "~/.vagrant.d/insecure_private_key"]
  config.ssh.forward_agent = true
  config.vm.provision "file", source: "/Users/michael/.ssh/michaelfisher.pub", destination: "~/.ssh/authorized_keys"
  config.vm.provision "shell", inline: <<-EOC
    sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
    sudo service ssh restart
  EOC

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  #config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
     # Customize the amount of memory on the VM:
  #   vb.memory = "3072"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  #
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y git vim python-pip
     sudo pip install ansible virtualenv
     ansible-playbook /vagrant_data/provision_vm.yml
   SHELL
end
