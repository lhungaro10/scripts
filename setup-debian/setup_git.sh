#!/bin/bash

# Cores para facilitar a leitura
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "\n${BLUE}--- Configuração do Git & SSH ---${NC}\n"

# 1. Configuração de Usuário e Email
echo "Vamos configurar sua identidade no Git."
echo "Se você deixar em branco, manterá a configuração atual (se existir)."

CURRENT_NAME=$(git config --global user.name)
read -p "Digite seu Nome [$CURRENT_NAME]: " GIT_NAME
GIT_NAME=${GIT_NAME:-$CURRENT_NAME}

CURRENT_EMAIL=$(git config --global user.email)
read -p "Digite seu Email [$CURRENT_EMAIL]: " GIT_EMAIL
GIT_EMAIL=${GIT_EMAIL:-$CURRENT_EMAIL}

if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    echo -e "${GREEN}Identidade configurada!${NC}"
else
    echo -e "${YELLOW}Nome ou Email não fornecidos. Pulando configuração de identidade.${NC}"
fi

# 2. Configurações Extras Recomendadas
git config --global init.defaultBranch master
git config --global core.editor "code --wait" # Define VS Code como editor (opcional, pode trocar por vim/nano)
# Melhora a exibição de logs
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

echo -e "${GREEN}Configurações extras (branch main, editor, alias) aplicadas.${NC}"

# 3. Configuração de SSH
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

echo -e "\n${BLUE}--- Verificando Chaves SSH ---${NC}"

if [ -f "$SSH_KEY_PATH" ]; then
    echo -e "${YELLOW}Uma chave SSH Ed25519 já existe em $SSH_KEY_PATH${NC}"
    read -p "Deseja gerar uma nova e SOBRESCREVER a atual? (s/N): " -n 1 -r OVERWRITE
    echo ""
    if [[ ! $OVERWRITE =~ ^[SsYy]$ ]]; then
        GENERATE_KEY=false
    else
        GENERATE_KEY=true
    fi
else
    GENERATE_KEY=true
fi

if [ "$GENERATE_KEY" = true ]; then
    echo "Gerando nova chave SSH..."
    # -C adiciona o email como comentário na chave para identificação
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_PATH" -N "" 
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add "$SSH_KEY_PATH" > /dev/null
    echo -e "${GREEN}Chave SSH gerada com sucesso!${NC}"
else
    echo "Mantendo a chave existente."
fi

# 4. Copiar para área de transferência e Pausar
echo -e "\n${BLUE}--- Adicionando ao GitHub ---${NC}"

if command -v xclip &> /dev/null; then
    xclip -selection clipboard < "$SSH_KEY_PATH.pub"
    echo -e "${GREEN}A chave pública foi copiada automaticamente para sua área de transferência!${NC}"
else
    echo -e "${YELLOW}O pacote 'xclip' não foi encontrado.${NC}"
    echo "Copie a chave abaixo manualmente:"
    echo -e "${BLUE}------------------------------------------------${NC}"
    cat "$SSH_KEY_PATH.pub"
    echo -e "${BLUE}------------------------------------------------${NC}"
fi

echo -e "\nAgora siga os passos:"
echo "1. Vá para: https://github.com/settings/ssh/new"
echo "2. Cole a chave (Ctrl+V) no campo 'Key'."
echo "3. Dê um título (ex: Debian Desktop) e salve."

echo ""
# AQUI ESTÁ A PAUSA SOLICITADA
read -p ">>> Pressione [ENTER] assim que tiver salvo a chave no GitHub para continuar..."

# 5. Teste de Conexão (Opcional, mas recomendado)
echo -e "\nTestando conexão com o GitHub..."
# O ssh -T retorna exit code 1 mesmo com sucesso (ele diz "Hi username!"), então ignoramos o erro
ssh -T git@github.com -o StrictHostKeyChecking=accept-new

if [ $? -eq 1 ]; then
    echo -e "\n${GREEN}Conexão verificada! O Git está pronto para uso.${NC}"
else
    echo -e "\n${YELLOW}Parece que houve um erro na autenticação. Verifique se copiou a chave corretamente.${NC}"
fi
