#!/bin/bash

# Tenta carregar o utils.sh se existir (para usar a função install_package)
# Se não existir, define uma função simples para o script não quebrar ao testar sozinho
if [ -f "./utils.sh" ]; then
    source ./utils.sh
else
    # Fallback caso o utils não seja encontrado
    install_package() {
        sudo apt-get install -y "$1"
    }
fi

echo -e "\n--- Verificação de Dependências ---\n"

DEPENDENCIES=(
    "git"
    "curl"
    "jq"
    "unzip"
    "build-essential"
    "ca-certificates"
    "gnupg"
    "xclip"
)

# 1. LOG: Exibe a lista para o usuário
echo "Os seguintes pacotes foram selecionados para instalação:"
for PKG in "${DEPENDENCIES[@]}"; do
    echo "  - $PKG"
done
echo "" # Pula uma linha

# 2. CONFIRMAÇÃO: Pergunta ao usuário
# -n 1: lê apenas 1 caractere
# -r: impede que a barra invertida seja interpretada como escape
read -p "Deseja prosseguir com a instalação? (S/n): " -n 1 -r REPLY
echo "" # Pula uma linha para organização visual

# 3. LÓGICA: Verifica a resposta
# Aceita S, s, Y, y ou apenas Enter (vazio) como "Sim"
if [[ $REPLY =~ ^[SsYy]$ ]] || [[ -z $REPLY ]]; then
    
    echo -e "\nIniciando instalação...\n"
    
    # Atualiza repositórios antes (boa prática)
    sudo apt-get update

    for PKG in "${DEPENDENCIES[@]}"; do
        # Chama a função que deve estar no utils.sh ou no topo deste arquivo
        install_package "$PKG"
    done

    echo -e "\nTodas as dependências foram processadas."

else
    echo -e "\nInstalação cancelada pelo usuário."
    # Se este script for parte de um fluxo maior, você pode querer usar 'return 1' 
    # ou apenas deixar terminar sem fazer nada.
fi
