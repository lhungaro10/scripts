#!/bin/bash
# Cores para output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

install_package() {
    PACKAGE_NAME=$1
    
    # Verifica se já está instalado para não perder tempo
    if dpkg -l | grep -q -w "$PACKAGE_NAME"; then
        echo -e "${GREEN}[OK]${NC} $PACKAGE_NAME já está instalado."
    else
        echo "Instalando $PACKAGE_NAME..."
        # DEBIAN_FRONTEND=noninteractive evita perguntas durante a instalação
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$PACKAGE_NAME"
    fi
}

update_repositories() {
    echo "Atualizando repositórios..."
    sudo apt-get update
}
