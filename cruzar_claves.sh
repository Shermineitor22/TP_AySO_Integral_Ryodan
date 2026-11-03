#!/bin/bash

# 1. Generar la clave SSH local
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

# 2. Configurar resoluciones en /etc/hosts
echo "192.168.56.5 pc-ubuntu" | sudo tee -a /etc/hosts
echo "192.168.56.6 pc-fedora" | sudo tee -a /etc/hosts

# 3. Guardar la clave propia en la carpeta compartida

cp ~/.ssh/id_ed25519.pub "/home/vagrant/compartido/pub_$(hostname).pub"

# 4. Copiar todas las claves que ya estén en la carpeta compartida al authorized_keys local
cat /home/vagrant/compartido/pub_*.pub > ~/.ssh/authorized_keys

# 5. Ajustar permisos esenciales de SSH
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# 6. Crear el inventario de Ansible 
sudo mkdir -p /home/vagrant/repogit/UTN-FRA_SO_Ansible/ejemplo_04/inventory
sudo tee /home/vagrant/repogit/UTN-FRA_SO_Ansible/ejemplo_04/inventory/hosts > /dev/null <<EOF
[testing]
pc-ubuntu

[produccion]
pc-fedora
EOF
