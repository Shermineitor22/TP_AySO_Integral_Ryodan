# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "primero" do |vmHost1|
    vmHost1.vm.box = "ubuntu/jammy64"
    vmHost1.vm.hostname = "VM1-Grupo-Ryodan"
    vmHost1.vm.network "private_network", ip: "192.168.56.5"
    
    vmHost1.vm.synced_folder 'compartido/', '/home/vagrant/compartido', 
    owner: 'vagrant', group: 'vagrant' 

    vmHost1.ssh.insert_key = true
    vmHost1.vm.disk :disk, size: "1GB", name: "#{vmHost1.vm.hostname}_extra_storage"
    vmHost1.vm.disk :disk, size: "2GB", name: "#{vmHost1.vm.hostname}_extra_storage2"
    vmHost1.vm.disk :disk, size: "3GB", name: "#{vmHost1.vm.hostname}_extra_storage3"
    vmHost1.vm.disk :disk, size: "5GB", name: "#{vmHost1.vm.hostname}_extra_storage4"

    vmHost1.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "VM1-Grupo-Ryodan"
      vb.cpus = 1
      vb.linked_clone = true
      vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      
    end    

    vmHost1.vm.provision "shell", path: "configurar_lvm_ubuntu.sh"
    vmHost1.vm.provision "shell", path: "script_Enable_ssh_password.sh"
    vmHost1.vm.provision "shell", privileged: false, path: "script_Fix_history.sh"
    vmHost1.vm.provision "shell", path: "instala_paquetes.sh"
    
    # Automatización: Registrar a Fedora en el /etc/hosts de Ubuntu
    vmHost1.vm.provision "shell", inline: <<-SHELL
      if ! grep -q "pc-fedora" /etc/hosts; then
        echo "192.168.56.6 pc-fedora" >> /etc/hosts
      fi
    SHELL

    vmHost1.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get install -y ansible
    SHELL

    vmHost1.vm.provision "shell", privileged: false, inline: <<-SHELL
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit
      git clone https://github.com/upszot/UTN-FRA_SO_onBording.git 
      git clone https://github.com/upszot/UTN-FRA_SO_Ansible.git
      git clone https://github.com/upszot/UTN-FRA_SO_Docker.git
    SHELL

    # Cruce de claves SSH y configuración de Ansible
    vmHost1.vm.provision "shell", privileged: false, path: "cruzar_claves.sh"
  end
  
  config.vm.define :segundo do |vmHost2|
    vmHost2.vm.box = "generic/fedora39"
    vmHost2.vm.hostname = "VM2-Grupo-Ryodan"
    vmHost2.vm.network "private_network", ip: "192.168.56.6"
    
    vmHost2.vm.synced_folder 'compartido/', '/home/vagrant/compartido'
  
    vmHost2.ssh.insert_key = true
    vmHost2.ssh.username = "vagrant"
    vmHost2.ssh.password = "vagrant"

    vmHost2.vm.disk :disk, size: "1GB", name: "#{vmHost2.vm.hostname}_extra_storage"
    vmHost2.vm.disk :disk, size: "2GB", name: "#{vmHost2.vm.hostname}_extra_storage2"
    vmHost2.vm.disk :disk, size: "3GB", name: "#{vmHost2.vm.hostname}_extra_storage3"
    vmHost2.vm.disk :disk, size: "5GB", name: "#{vmHost2.vm.hostname}_extra_storage4"

    vmHost2.vm.provider "virtualbox" do |vb2|
      vb2.memory = "1024"
      vb2.name = "VM2-Grupo-Ryodan"
      vb2.cpus = 1
      vb2.linked_clone = true
      vb2.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    end
    
    vmHost2.vm.provision "shell", path: "configurar_lvm_fedora.sh"
    vmHost2.vm.provision "shell", path: "script_Enable_ssh_password.sh"
    vmHost2.vm.provision "shell", privileged: false, path: "script_Fix_history.sh"

    # Forzar la IP estática en Fedora mediante NetworkManager automáticamente
    vmHost2.vm.provision "shell", inline: <<-SHELL
      NM_CONN=$(nmcli -t -f NAME,DEVICE connection show | grep ':eth1$' | cut -d: -f1)
      if [ -z "$NM_CONN" ]; then
        NM_CONN="Wired connection 2"
      fi
      nmcli connection modify "$NM_CONN" ipv4.addresses 192.168.56.6/24 ipv4.method manual
      nmcli connection up "$NM_CONN"
    SHELL

    # Automatización: Registrar a Ubuntu en el /etc/hosts de Fedora para resolver "pc-ubuntu"
    vmHost2.vm.provision "shell", inline: <<-SHELL
      if ! grep -q "pc-ubuntu" /etc/hosts; then
        echo "192.168.56.5 pc-ubuntu" >> /etc/hosts
      fi
    SHELL

    vmHost2.vm.provision "shell", inline: <<-SHELL
      dnf install -y ansible tree git
    SHELL

    vmHost2.vm.provision "shell", privileged: false, inline: <<-SHELL
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit
      git clone https://github.com/upszot/UTN-FRA_SO_onBording.git 
      git clone https://github.com/upszot/UTN-FRA_SO_Ansible.git
      git clone https://github.com/upszot/UTN-FRA_SO_Docker.git
    SHELL

    # Cruce de claves SSH y configuración de Ansible
    vmHost2.vm.provision "shell", privileged: false, path: "cruzar_claves.sh"
  end
end
