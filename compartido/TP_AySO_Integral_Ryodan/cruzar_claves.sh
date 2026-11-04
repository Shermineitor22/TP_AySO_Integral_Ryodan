#!/bin/bash

# 1. Generar la clave SSH
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

# 2. Configurar resoluciones en /etc/hosts
echo "192.168.56.5 pc-ubuntu" | sudo tee -a /etc/hosts
echo "192.168.56.6 pc-fedora" | sudo tee -a /etc/hosts

# 3. Copiar la clave propia a la carpeta compartida
cp ~/.ssh/id_ed25519.pub "/home/vagrant/compartido/pub_$(hostname).pub"

# 4. Esperar a que ambas máquinas compartan sus claves
while [ $(ls -1 /home/vagrant/compartido/pub_*.pub 2>/dev/null | wc -l) -lt 2 ]; do
    sleep 2
done

# 5. Unificar claves en authorized_keys
cat /home/vagrant/compartido/pub_*.pub > ~/.ssh/authorized_keys

# 6. Ajustar permisos de SSH
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# 7. Crear el inventario de Ansible 
sudo mkdir -p /home/vagrant/repogit/UTN-FRA_SO_Ansible/ejemplo_04/inventory
sudo tee /home/vagrant/repogit/UTN-FRA_SO_Ansible/ejemplo_04/inventory/hosts > /dev/null <<EOF
[testing]
pc-ubuntu

[produccion]
pc-fedora
EOF
