#!/bin/bash

# Carrega utilitários comuns
if [ -f "./scripts/utils.sh" ]; then
    source ./scripts/utils.sh
else
    echo "Erro: utils.sh não encontrado."
    # Define cores básicas caso utils falhe, para não quebrar os echos coloridos abaixo
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    NC='\033[0m'
fi

# ==========================================
# LISTA DE MÓDULOS
# ==========================================
AVAILABLE_MODULES=(
    "scripts/install_dependencies.sh|Dependências do Sistema (Essencial)"
    "scripts/setup_git.sh|Configuração do Git & SSH"
    "scripts/setup_zsh.sh|Terminal Zsh & Oh My Zsh + Starship"
    "scripts/setup_nvm.sh|Node.js (NVM), NPM e Yarn"   # <--- NOVA LINHA AQUI
    "scripts/setup_docker.sh|Docker Engine & Docker Compose"
    "scripts/setup_java.sh|Java 17 LTS (OpenJDK) & JAVA_HOME"
    "scripts/setup_vscode.sh|Visual Studio Code & Extensões"
)

TO_EXECUTE=()

clear
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}      Debian 13 Setup Orchestrator       ${NC}"
echo -e "${BLUE}=========================================${NC}\n"

# 1. Opção de Setup Completo
echo "Deseja executar a instalação COMPLETA (todos os módulos)?"
read -p "Pressione [ENTER] para Sim ou 'n' para escolher manualmente: " -n 1 -r REPLY_ALL
echo -e "\n"

if [[ $REPLY_ALL =~ ^[SsYy]$ ]] || [[ -z $REPLY_ALL ]]; then
    # --- MODO AUTOMÁTICO ---
    echo -e "${GREEN}>> Modo Completo selecionado.${NC}"
    for ITEM in "${AVAILABLE_MODULES[@]}"; do
        SCRIPT_NAME="${ITEM%%|*}"
        TO_EXECUTE+=("$SCRIPT_NAME")
    done
else
    # --- MODO MANUAL ---
    echo "Selecione os módulos individualmente:"
    echo "-------------------------------------"
    
    for ITEM in "${AVAILABLE_MODULES[@]}"; do
        SCRIPT_NAME="${ITEM%%|*}"
        DESCRIPTION="${ITEM##*|}"

        read -p "$(echo -e "Executar [${GREEN}$DESCRIPTION${NC}]? (S/n): ")" -n 1 -r REPLY
        echo "" 

        if [[ $REPLY =~ ^[SsYy]$ ]] || [[ -z $REPLY ]]; then
            TO_EXECUTE+=("$SCRIPT_NAME")
        else
            echo -e "${YELLOW}-> Pulando $DESCRIPTION${NC}\n"
        fi
    done
fi

# 2. Verificação e Confirmação
if [ ${#TO_EXECUTE[@]} -eq 0 ]; then
    echo -e "\n${RED}Nenhum módulo selecionado. Saindo...${NC}"
    exit 0
fi

echo -e "\n${BLUE}=========================================${NC}"
echo -e "Resumo do que será executado:"
for SCRIPT in "${TO_EXECUTE[@]}"; do
    echo -e "  -> ${GREEN}$SCRIPT${NC}"
done
echo -e "${BLUE}=========================================${NC}"

read -p "Confirma o início da configuração? (S/n): " -n 1 -r CONFIRM
echo ""
if [[ ! $CONFIRM =~ ^[SsYy]$ ]] && [[ -n $CONFIRM ]]; then
    echo "Operação cancelada."
    exit 0
fi

# 3. Execução
echo -e "\nIniciando..."

for SCRIPT in "${TO_EXECUTE[@]}"; do
    if [ -f "$SCRIPT" ]; then
        # Garante permissão de execução
        chmod +x "$SCRIPT"

        # Executa o script
        "$SCRIPT"
        
        EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            echo -e "\n${RED}ERRO: O script $SCRIPT falhou (Código $EXIT_CODE).${NC}"
            read -p "Deseja continuar com os próximos? (s/N): " -n 1 -r CONT
            echo ""
            if [[ ! $CONT =~ ^[SsYy]$ ]]; then
                echo "Abortando setup."
                exit 1
            fi
        fi
    else
        echo -e "\n${RED}ERRO Crítico: Arquivo $SCRIPT não encontrado!${NC}"
    fi
done

echo -e "\n${GREEN}Setup Finalizado com Sucesso!${NC}"
