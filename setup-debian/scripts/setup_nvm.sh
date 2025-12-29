#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\n${BLUE}--- Configuração do NVM (Node Version Manager) ---${NC}\n"

# Define a versão do NVM a ser instalada
# Verifique periodicamente em https://github.com/nvm-sh/nvm/releases
NVM_VERSION="v0.40.1"

# 1. Instalação / Atualização do NVM
echo "Baixando e instalando NVM $NVM_VERSION..."

# Cria o diretório se não existir (evita erros em casos raros)
mkdir -p "$HOME/.nvm"

# Executa o script oficial de instalação
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

# 2. Carregar NVM na sessão atual
# O instalador adiciona linhas ao .bashrc/.zshrc, mas elas só funcionam
# em novos terminais. Para usar AGORA, precisamos exportar manualmente.
echo "Carregando NVM na sessão atual..."

export NVM_DIR="$HOME/.nvm"
# Carrega o nvm script
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Carrega o nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Verificação se o carregamento funcionou
if command -v nvm &> /dev/null; then
    echo -e "${GREEN}NVM instalado e carregado com sucesso!${NC}"
else
    echo -e "${RED}Erro ao carregar o NVM. Verifique se o arquivo ~/.nvm/nvm.sh existe.${NC}"
    exit 1
fi

# 3. Instalar Node.js LTS
echo -e "\n${BLUE}--- Instalando Node.js (LTS) ---${NC}"

echo "Instalando versão LTS..."
nvm install --lts

echo "Definindo LTS como padrão..."
nvm alias default lts/*
nvm use default

# 4. Ferramentas Globais Úteis
echo -e "\n${BLUE}--- Instalando Ferramentas Globais ---${NC}"

echo "Atualizando NPM..."
npm install -g npm@latest

echo "Instalando Yarn..."
npm install -g yarn

# 5. Validação e Limpeza
echo -e "\n${BLUE}--- Validação ---${NC}"
NODE_V=$(node -v)
NPM_V=$(npm -v)
YARN_V=$(yarn -v)

echo -e "Node: ${GREEN}$NODE_V${NC}"
echo -e "NPM:  ${GREEN}$NPM_V${NC}"
echo -e "Yarn: ${GREEN}$YARN_V${NC}"

echo -e "\n${GREEN}Setup do Node.js finalizado!${NC}"
echo -e "${YELLOW}Nota: Se você trocar de shell (ex: instalar Zsh DEPOIS deste script),${NC}"
echo -e "${YELLOW}o NVM pode não carregar. Recomenda-se rodar o setup do Zsh ANTES do NVM.${NC}"