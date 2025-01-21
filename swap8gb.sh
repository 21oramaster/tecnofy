#!/bin/bash

# Nome do arquivo de swap
SWAP_FILE=/swapfile

# Tamanho do arquivo de swap em gigabytes
SWAP_SIZE=8

# Verificar se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root ou use sudo"
  exit 1
fi

# Verificar se já existe um arquivo de swap
if [ -f "$SWAP_FILE" ]; then
  echo "Arquivo de swap já existe. Saindo..."
  exit 1
fi

# Criar o arquivo de swap
echo "Criando arquivo de swap de ${SWAP_SIZE}GB..."
sudo fallocate -l ${SWAP_SIZE}G $SWAP_FILE

# Verificar se o comando fallocate falhou
if [ $? -ne 0 ]; then
  echo "fallocate falhou. Tentando com dd..."
  sudo dd if=/dev/zero of=$SWAP_FILE bs=1M count=$((SWAP_SIZE * 1024))
fi

# Definir permissões corretas
echo "Configurando permissões..."
sudo chmod 600 $SWAP_FILE

# Configurar o arquivo como swap
echo "Configurando o arquivo como swap..."
sudo mkswap $SWAP_FILE

# Ativar o arquivo de swap
echo "Ativando o arquivo de swap..."
sudo swapon $SWAP_FILE

# Verificar se o arquivo de swap está ativo
echo "Verificando a configuração..."
sudo swapon --show

# Tornar a configuração permanente
echo "Tornando a configuração permanente..."
echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab

# Ajustar a "swappiness" (opcional)
echo "Ajustando a 'swappiness'..."
sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "Configuração de swap concluída com sucesso!"
