#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\n${BLUE}--- Configuração do Java (OpenJDK) ---${NC}\n"

# 1. Tentar encontrar a versão correta
# Debian Trixie (13) pode priorizar o Java 21. Vamos verificar qual instalar.
echo "Atualizando lista de pacotes..."
sudo apt-get update -qq

JAVA_PKG=""

# Verifica se o Java 17 existe
if apt-cache show openjdk-17-jdk >/dev/null 2>&1; then
    JAVA_PKG="openjdk-17-jdk openjdk-17-source"
    JAVA_VERSION="17"
    echo -e "${GREEN}Java 17 encontrado nos repositórios.${NC}"
# Verifica se o Java 21 existe (Fallback recomendado)
elif apt-cache show openjdk-21-jdk >/dev/null 2>&1; then
    echo -e "${YELLOW}Java 17 não encontrado. O Debian 13 prioriza versões mais novas.${NC}"
    echo -e "${GREEN}Selecionando Java 21 (LTS Atual) como alternativa.${NC}"
    JAVA_PKG="openjdk-21-jdk openjdk-21-source"
    JAVA_VERSION="21"
else
    # Fallback final para o default do sistema
    echo -e "${YELLOW}Versões específicas não encontradas. Usando 'default-jdk'.${NC}"
    JAVA_PKG="default-jdk"
    JAVA_VERSION="default"
fi

# 2. Instalação
echo "Instalando pacotes selecionados ($JAVA_PKG)..."
if sudo apt-get install -y $JAVA_PKG; then
    echo -e "${GREEN}Instalação concluída com sucesso via APT.${NC}"
else
    echo -e "${RED}Falha crítica na instalação do apt. Abortando.${NC}"
    exit 1
fi

# 3. Descobrir o JAVA_HOME dinamicamente
# Isso evita o erro de "diretório não encontrado" se o caminho mudar
echo -e "\n${BLUE}--- Detectando Caminho de Instalação ---${NC}"

# update-alternatives nos dá o caminho real do comando 'java'
JAVA_BIN_PATH=$(update-alternatives --list java | head -n 1)

# Se o java não foi achado no update-alternatives (raro), tenta which
if [ -z "$JAVA_BIN_PATH" ]; then
    JAVA_BIN_PATH=$(readlink -f $(which java))
fi

if [ -z "$JAVA_BIN_PATH" ]; then
    echo -e "${RED}ERRO: Não foi possível localizar o binário do java instalado.${NC}"
    exit 1
fi

# O caminho do binário é algo como /usr/lib/jvm/java-17-openjdk-amd64/bin/java
# Precisamos subir dois níveis para pegar o JAVA_HOME (/usr/lib/jvm/java-17-openjdk-amd64)
REAL_JAVA_HOME=$(dirname $(dirname "$JAVA_BIN_PATH"))

echo "Caminho detectado: $REAL_JAVA_HOME"

# 4. Configuração de Variáveis de Ambiente
FILES_TO_UPDATE=("$HOME/.bashrc" "$HOME/.zshrc")

echo -e "\n${BLUE}--- Configurando JAVA_HOME nos arquivos de shell ---${NC}"

for RC_FILE in "${FILES_TO_UPDATE[@]}"; do
    if [ -f "$RC_FILE" ]; then
        # Remove configurações antigas de JAVA_HOME para evitar duplicidade ou conflito
        # (Opcional, mas limpa o arquivo se você rodar o script várias vezes)
        sed -i '/export JAVA_HOME=/d' "$RC_FILE"
        sed -i '/export PATH=\$JAVA_HOME\/bin:\$PATH/d' "$RC_FILE"
        
        echo "" >> "$RC_FILE"
        echo "export JAVA_HOME=$REAL_JAVA_HOME" >> "$RC_FILE"
        echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> "$RC_FILE"
        echo -e "${GREEN}Configuração atualizada no $RC_FILE${NC}"
    fi
done

# 5. Validação
echo -e "\n${BLUE}--- Validação ---${NC}"
export JAVA_HOME="$REAL_JAVA_HOME"
export PATH="$JAVA_HOME/bin:$PATH"

java -version
echo ""
echo -e "JAVA_HOME configurado para: $JAVA_HOME"
echo -e "${GREEN}Java Setup Finalizado! Reinicie seu terminal.${NC}"
