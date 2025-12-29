#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\n${BLUE}--- Setup do Docker Engine ---${NC}\n"

echo -e "\n${BLUE}--- 1. Preparação de Dependências e Chaves ---${NC}\n"

sudo apt-get update -qq
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo -e "\n${BLUE}--- Cria diretório de chaves se não existir ---${NC}\n"
sudo install -m 0755 -d /etc/apt/keyrings

if [ -f "/etc/apt/keyrings/docker.asc" ]; then
    echo -e "${YELLOW}Chave GPG já existe. Atualizando...${NC}"
fi

sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo -e "\n${BLUE}--- 2. Adicionar Repositório Oficial ---${NC}\n"

# Detecta o codename do Debian (ex: trixie, bookworm)
DEBIAN_CODENAME=$(lsb_release -cs)

# Nota: Se o repositório oficial ainda não tiver suporte explícito ao "trixie" (por ser testing),
# o apt pode falhar. Uma prática comum é usar o codename da última estável (bookworm) se isso ocorrer.
# O comando abaixo tenta usar o codename atual do sistema.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $DEBIAN_CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "${GREEN}Repositório adicionado para Debian ($DEBIAN_CODENAME).${NC}"


echo -e "\n${BLUE}--- 3. Instalando Docker Engine e plugins ---${NC}\n"

sudo apt-get update
# docker-ce: O motor do Docker
# docker-ce-cli: Linha de comando
# containerd.io: Runtime de containers
# docker-buildx-plugin: Para builds avançados
# docker-compose-plugin: O comando 'docker compose' (substituto do antigo docker-compose)
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Configuração de Usuário (Rootless mode)
echo -e "\n${BLUE}--- 4. Configuração de Permissões ---${NC}"

if getent group docker | grep -q "\b$USER\b"; then
    echo -e "${GREEN}Usuário $USER já está no grupo docker.${NC}"
else
    echo "Adicionando usuário $USER ao grupo 'docker'..."
    sudo usermod -aG docker "$USER"
    echo -e "${YELLOW}AVISO: Você precisará fazer logoff/login ou reiniciar para usar o docker sem sudo.${NC}"
    
    # Tenta ativar o grupo na sessão atual (pode não funcionar em todos os shells sem re-login)
    newgrp docker > /dev/null 2>&1 || true
fi

# 6. Teste Final
echo -e "\n${BLUE}--- 6. Teste de Instalação ---${NC}"
read -p "Deseja rodar o container de teste 'hello-world'? (S/n): " -n 1 -r REPLY
echo ""
if [[ $REPLY =~ ^[SsYy]$ ]] || [[ -z $REPLY ]]; then
    echo "Rodando hello-world..."
    # Tenta rodar sem sudo primeiro. Se falhar, avisa sobre o re-login e tenta com sudo.
    if docker run --rm hello-world; then
        echo -e "\n${GREEN}Sucesso! Docker está rodando perfeitamente sem sudo.${NC}"
    else
        echo -e "\n${YELLOW}Não foi possível rodar sem sudo (o grupo ainda não foi atualizado na sessão).${NC}"
        echo "Tentando com sudo para validar a instalação..."
        sudo docker run --rm hello-world
        echo -e "\n${YELLOW}Nota: Para rodar sem sudo, lembre-se de reiniciar sua sessão/computador.${NC}"
    fi
fi

echo -e "\n${BLUE}---  ---${NC}\n"
