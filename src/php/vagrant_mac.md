# PHP开发环境配置 #

## 安装 Virtualbox

+ Virtualbox
    - [5.2.26](https://download.virtualbox.org/virtualbox/5.2.26/VirtualBox-5.2.26-128414-OSX.dmg)

## 安装 Vagrant

+ vagrant
    - [vagrant 2.1.0](https://releases.hashicorp.com/vagrant/2.1.0/vagrant_2.1.0_x86_64.dmg)
+ homestead
    - [homestead 7.1.0](https://vagrantcloud.com/laravel/boxes/homestead/versions/7.1.0/providers/virtualbox.box)
    - [homestead 8.0.1](https://vagrantcloud.com/laravel/boxes/homestead/versions/8.0.1/providers/virtualbox.box)

Vagrant 配置

metadata.json
```json
{
    "name": "laravel/homestead",
    "versions": [{
        "version": "7.1.0",
        "providers": [{
            "name": "virtualbox",
            "url": "v7.1.0.box"
        }]
    }]
}
```

1. vagrant box add metadata.json
2. [Homestead](https://laravel.com/docs/5.8/homestead)

./ssh/config
```bash
Host laravel
    HostName 127.0.0.1
    User vagrant
    Port 2222
```
