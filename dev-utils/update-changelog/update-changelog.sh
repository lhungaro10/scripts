#!/bin/bash

set -e # Para o script se houver erro

# === CONFIGURAÇÃO DO TEMPLATE ===
define_template() {
    cat <<EOF
## [Unreleased]

### Added

- 

### Changed

- 

### Fixed

- 

### Removed

- 
EOF
}

# === FUNÇÕES DE AJUDA ===

usage() {
    echo "Uso: $0 <caminho_do_changelog> <major|minor|patch>"
    exit 1
}

# Verifica argumentos
if [ "$#" -ne 2 ]; then
    usage
fi

FILE_PATH="$1"
PART="$2"

# Verifica se o arquivo existe
if [ ! -f "$FILE_PATH" ]; then
    echo "Erro: Arquivo não encontrado em $FILE_PATH"
    exit 1
fi

# 1. Obter a versão atual (primeira ocorrência de ## [x.x.x])
# Usa grep para achar a linha e sed para extrair os números
CURRENT_VERSION_LINE=$(grep -m 1 -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" "$FILE_PATH" || echo "0.0.0")

if [ "$CURRENT_VERSION_LINE" == "0.0.0" ]; then
    MAJOR=0; MINOR=0; PATCH=0
else
    # Extrai apenas os números da string "## [1.2.3] ..."
    VERSION_ONLY=$(echo "$CURRENT_VERSION_LINE" | sed -E 's/.*\[([0-9]+)\.([0-9]+)\.([0-9]+)\].*/\1 \2 \3/')
    read -r MAJOR MINOR PATCH <<< "$VERSION_ONLY"
fi

# 2. Calcular nova versão
case "$PART" in
    major)
        NEW_VERSION="$((MAJOR + 1)).0.0"
        ;;
    minor)
        NEW_VERSION="$((MAJOR)).$((MINOR + 1)).0"
        ;;
    patch)
        NEW_VERSION="$((MAJOR)).$((MINOR)).$((PATCH + 1))"
        ;;
    *)
        echo "Erro: Tipo de versão inválido. Use major, minor ou patch."
        exit 1
        ;;
esac

TODAY=$(date +%Y-%m-%d)

echo "Atualizando de $MAJOR.$MINOR.$PATCH para $NEW_VERSION ($TODAY)..."

# 3. Extrair e Processar Partes do Arquivo

# Cria arquivos temporários
TEMP_HEADER=$(mktemp)
TEMP_UNRELEASED=$(mktemp)
TEMP_HISTORY=$(mktemp)
TEMP_FINAL=$(mktemp)

# A. Extrai o cabeçalho (tudo antes de ## [Unreleased])
awk '
    /^## \[Unreleased\]/ { exit }
    { print }
' "$FILE_PATH" > "$TEMP_HEADER"

# B. Extrai o conteúdo atual de [Unreleased] (entre Unreleased e a próxima versão)
# Nota: sed imprime entre padrões, 'head' remove a ultima linha (que seria o titulo da proxima versao)
sed -n '/^## \[Unreleased\]/,/^## \[/p' "$FILE_PATH" | sed '1d' | head -n -1 > "$TEMP_UNRELEASED"

# C. Extrai o histórico antigo (da primeira versão numerada até o fim)
# Acha a linha da versão antiga e imprime até o fim
sed -n "/^## \[$MAJOR\.$MINOR\.$PATCH\]/,\$p" "$FILE_PATH" > "$TEMP_HISTORY"

# 4. Limpar seções vazias do Unreleased
# Lógica: Remove blocos "### Header" seguidos imediatamente por "-" ou vazios
CLEANED_UNRELEASED=$(cat "$TEMP_UNRELEASED" | awk '
    BEGIN { RS=""; ORS="\n\n" } # Lê por parágrafos (separados por linha vazia)
    {
        # Se o parágrafo contém "###" (é um cabeçalho)
        if ($0 ~ /^###/) {
            # Verifica se tem conteúdo real (algo além de hifens, espaços ou o próprio cabeçalho)
            # Divide o bloco em linhas
            n = split($0, lines, "\n")
            has_content = 0
            for (i=2; i<=n; i++) {
                # Se a linha tiver letras ou números, é conteúdo válido
                if (lines[i] ~ /[a-zA-Z0-9]/) {
                    has_content = 1
                }
            }
            if (has_content) {
                print $0
            }
        } else {
            # Se não for um bloco de cabeçalho padrão, imprime (segurança)
            if ($0 ~ /[a-zA-Z0-9]/) print $0
        }
    }
' | sed '/^$/d') # Remove linhas vazias extras

# 5. Montagem do Arquivo Final

# Cabeçalho Original
cat "$TEMP_HEADER" > "$TEMP_FINAL"

# Novo Template Unreleased
define_template >> "$TEMP_FINAL"
echo "" >> "$TEMP_FINAL" # Garante espaçamento

# Nova Versão (Header + Conteúdo Limpo)
echo "## [$NEW_VERSION] - $TODAY" >> "$TEMP_FINAL"
echo "" >> "$TEMP_FINAL"

if [ -z "$CLEANED_UNRELEASED" ]; then
    echo "" >> "$TEMP_FINAL"
else
    echo "$CLEANED_UNRELEASED" >> "$TEMP_FINAL"
    echo "" >> "$TEMP_FINAL"
fi

# Histórico Antigo
cat "$TEMP_HISTORY" >> "$TEMP_FINAL"

# 6. Substitui o arquivo original
mv "$TEMP_FINAL" "$FILE_PATH"

# Remove temporários
rm -f "$TEMP_HEADER" "$TEMP_UNRELEASED" "$TEMP_HISTORY"

echo "Sucesso! Changelog atualizado para versão $NEW_VERSION."