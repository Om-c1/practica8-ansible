FROM ubuntu:22.04

# Evitar preguntas interactivas durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar OpenSSH Server, sudo y Python 3 (requerido por Ansible)
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 && \
    mkdir -p /var/run/sshd

# Crear el usuario 'ansible' con contraseña 'ansible' y agregarlo al grupo sudo
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    usermod -aG sudo ansible

# Configurar privilegios sudo sin contraseña para el usuario 'ansible'
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Exponer el puerto 22 para conexiones SSH
EXPOSE 22

# Iniciar el servicio SSH en primer plano al arrancar el contenedor
CMD ["/usr/sbin/sshd", "-D"]