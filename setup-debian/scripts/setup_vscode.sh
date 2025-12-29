#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\n${BLUE}--- Configuração do Visual Studio Code ---${NC}\n"

# 1. Adicionar Repositório e Chave GPG
if command -v code &> /dev/null; then
    echo -e "${YELLOW}O VS Code já parece estar instalado.${NC}"
    read -p "Deseja reinstalar/atualizar e processar as extensões? (s/N): " -n 1 -r REPLY
    echo ""
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        echo "Pulando instalação do binário."
        SKIP_INSTALL=true
    fi
fi

if [ "$SKIP_INSTALL" != true ]; then
    echo "Configurando repositório oficial da Microsoft..."
    
    # Instala dependências para transporte HTTPS
    sudo apt-get install -y wget gpg apt-transport-https

    # Baixa a chave GPG, converte e salva no chaveiro do sistema
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    rm packages.microsoft.gpg

    # Adiciona o repositório à lista do APT
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

    echo "Instalando o pacote 'code'..."
    sudo apt-get update -qq
    sudo apt-get install -y code

    echo -e "${GREEN}VS Code instalado com sucesso!${NC}"
fi

# 2. Instalação Automática de Extensões
echo -e "\n${BLUE}--- Instalando Extensões Recomendadas ---${NC}"

# Lista de extensões (IDs do Marketplace)
# Adicione ou remova conforme sua necessidade
EXTENSIONS=(
    # Produtividade e Git
    "eamodio.gitlens"           # Git supercharged
    "mhutchie.git-graph"        # Visualização gráfica do git
    
    # Docker / Infra
    "ms-azuretools.vscode-docker"
    
    # Web / JS / TS
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "yoavbls.pretty-ts-errors"  # Torna erros de TS legíveis
    
    # Visual
    "pkief.material-icon-theme" # Ícones para pastas/arquivos
    "dracula-theme.theme-dracula" # Tema clássico (opcional)
)

# Verifica se o comando 'code' está disponível antes de tentar instalar extensões
if command -v code &> /dev/null; then
    for EXT in "${EXTENSIONS[@]}"; do
        # Verifica se já está instalada para ganhar tempo
        if code --list-extensions | grep -qFi "$EXT"; then
            echo -e "${YELLOW}[OK] $EXT já instalada.${NC}"
        else
            echo "Instalando $EXT..."
            code --install-extension "$EXT" --force
        fi
    done
    echo -e "${GREEN}Processo de extensões finalizado.${NC}"
else
    echo -e "${RED}Erro: O comando 'code' não foi encontrado. As extensões não puderam ser instaladas.${NC}"
fi

# 3. Configuração de Settings (Opcional - via arquivo local ou dica de Sync)
echo -e "\n${BLUE}--- Dica de Sincronização ---${NC}"
echo "O VS Code possui o 'Settings Sync' nativo vinculado à sua conta GitHub."
echo "Recomendamos que você faça login no ícone de engrenagem -> 'Turn on Settings Sync'"
echo "para baixar seus keybindings e configurações pessoais (settings.json)."
