#!/bin/bash

# 1. Generar la clave SSH
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

# 2. Copiar las claves a las máquinas
ssh-copy-id 192.168.56.5
ssh-copy-id 192.168.56.6

# 3. Configurar la resolución de nombres 
echo "192.168.56.5 pc-ubuntu" | sudo tee -a /etc/hosts
echo "192.168.56.6 pc-fedora" | sudo tee -a /etc/hosts

# 4. Crear el inventario de Ansible
sudo tee /repogit/UTN-FRA_SO_Ansible/ejemplo_04/inventory/hosts > /dev/null <<EOF
[testing]
pc-ubuntu

[produccion]
pc-fedora
EOF
