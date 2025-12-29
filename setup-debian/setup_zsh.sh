#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\n${BLUE}--- Configuração do Terminal ZSH & Starship ---${NC}\n"

# 1. Instalar ZSH e Fontes Básicas
echo "Instalando Zsh e fontes Powerline..."
sudo apt-get update -qq
# Adicionamos curl e git aqui caso este script rode isolado
sudo apt-get install -y zsh fonts-powerline curl git

# 2. Verificar se o Oh My Zsh já existe
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Oh My Zsh já está instalado.${NC}"
else
    echo "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}Oh My Zsh instalado com sucesso!${NC}"
fi

# 3. Instalar Plugins do ZSH
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
echo -e "\n${BLUE}--- Instalando Plugins do Zsh ---${NC}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Baixando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Baixando zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# 4. Configurar .zshrc (Plugins)
echo -e "\n${BLUE}--- Configurando .zshrc ---${NC}"
ZSHRC_FILE="$HOME/.zshrc"

if grep -q "zsh-autosuggestions" "$ZSHRC_FILE"; then
    echo -e "${YELLOW}Plugins já configurados.${NC}"
else
    echo "Ativando plugins..."
    sed -i.bak 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC_FILE"
fi

# ==============================================================================
# 5. INSTALAÇÃO E CONFIGURAÇÃO DO STARSHIP
# ==============================================================================
echo -e "\n${BLUE}--- Configurando Starship Prompt ---${NC}"

# A. Instala o binário
if ! command -v starship &> /dev/null; then
    echo "Baixando e instalando Starship..."
    # -y confirma a instalação automaticamente e instala em /usr/local/bin
    curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
    echo -e "${GREEN}Starship instalado.${NC}"
else
    echo -e "${YELLOW}Starship já está instalado.${NC}"
fi

# B. Baixa sua configuração personalizada (TOML)
echo "Baixando starship.toml personalizado..."
mkdir -p "$HOME/.config"

# URL convertida para RAW para baixar o conteúdo correto
CONFIG_URL="https://raw.githubusercontent.com/lhungaro10/config-files/master/starship.toml"

if curl -fsSL "$CONFIG_URL" -o "$HOME/.config/starship.toml"; then
    echo -e "${GREEN}Configuração baixada em ~/.config/starship.toml${NC}"
else
    echo -e "${RED}Erro ao baixar o arquivo starship.toml. Verifique a URL.${NC}"
fi

# C. Configura o .zshrc para iniciar o Starship
# O Starship deve ser a última coisa a carregar no .zshrc
if grep -q "starship init zsh" "$ZSHRC_FILE"; then
    echo -e "${YELLOW}Starship já está ativado no .zshrc.${NC}"
else
    echo "Adicionando init do Starship ao final do .zshrc..."
    echo "" >> "$ZSHRC_FILE"
    echo "# Inicialização do Starship Prompt" >> "$ZSHRC_FILE"
    echo 'eval "$(starship init zsh)"' >> "$ZSHRC_FILE"
    echo -e "${GREEN}Starship ativado!${NC}"
fi

# ==============================================================================

# 6. Definir Zsh como Shell Padrão
echo -e "\n${BLUE}--- Definindo Shell Padrão ---${NC}"

CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" = "zsh" ]; then
    echo -e "${GREEN}Zsh já é o shell padrão.${NC}"
else
    chsh -s "$(which zsh)"
    echo -e "${GREEN}Shell padrão alterado para Zsh. Reinicie a sessão para ver as mudanças.${NC}"
fi
