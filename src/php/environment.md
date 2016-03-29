# PHP开发环境配置 #

## 下载 PHP

[php-5.6.19-Win32-VC11-x64](http://windows.php.net/downloads/releases/php-5.6.19-Win32-VC11-x64.zip)

## 安装 Git

下载 [Git-2.7.4-64-bit](https://github.com/git-for-windows/git/releases/download/v2.7.4.windows.1/Git-2.7.4-64-bit.exe)

## 安装 Virtualbox

下载 [VirtualBox-4.3.4-91027-Win](http://download.virtualbox.org/virtualbox/4.3.4/VirtualBox-4.3.4-91027-Win.exe)

## 安装 Vagrant

下载 [vagrant_1.8.1](https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1.msi)

Vagrant 配置

1. vagrant init hashicorp/precise32；
2. vagrant init laravel/homestead "file://F:/Boxes/homestead-0-2-5-vb.box"
3. vagrant box add laravel/homestead "file://F:/Boxes/homestead-0-2-5-vb.box"
4. vagrant box add chef/centos-6.5 "file://F:/Boxes/homestead-0-2-5-vb.box"

```bash
1. vagrant up
2. vagrant reload
3. vagrant destroy
```

```bash
Vagrant 环境变量

1. VAGRANT_CWD；【用于vagrant寻找Vagrantfile文件，例如命令行】
2. VAGRANT_HOME；【Vagrant主目录，默认~/.vagrant.d，windows下设置环境变量】
	1. export VAGRANT_HOME=f:\\Vagrant

3. VAGRABT_LOG；【默认不记录日志，日志级别：debug、info、warn、error】
4. VAGRANT_NO_PLUGINS；【如果设置则不加载任何plug-ins】
5. VAGRANT_VAGRANTFILE；【设置vagrantfile文件名，不是路径】
```

```bash
VirtualBox bug

1. Nginx sendfile off
2. Apache EnableSendfile Off
```

```ruby
Vagrantfile

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "laravel/homestead"

  config.vm.box_url = "file://E\:/VirtualBox/homestead-0-2-5-vb.box"

  config.vm.box_check_update = false

  config.vm.hostname = 'laravel'

  config.vm.network "forwarded_port", guest: 80, host: 80, protocol: 'tcp', auto_correct: true
  config.vm.network "forwarded_port", guest: 80, host: 80, protocol: 'udp', auto_correct: true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "private_network", type: "dhcp"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.synced_folder "E:/www/", "/home/www"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.cpus   = 2
    vb.name   = "laravel"
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  # config.ssh.private_key_path="F:/virtualbox/private_key"

end

```

## Xshell && Xftp

下载 [Xshell](./Xftp4.exe)
下载 [Xftp](./Xshell4_4.0.0.125.exe)