
# 🚀 Instruções de Uso - Update Changelog

## 📋 Descrição

Script automatizado para atualizar e manter o arquivo CHANGELOG de forma padronizada e eficiente. Facilita o registro de mudanças, versões e melhorias do projeto.

---

## ⚙️ Pré-requisitos

### Sistema Operacional
- **Debian 13** (Trixie) ou compatível
- Usuário com privilégios básicos
- Projeto com arquivo `CHANGELOG.md` existente

### Antes de Executar
```bash
# 1. Navegue até o diretório do script
cd ~/scripts/dev-utils/update-changelog

# 2. Verifique a estrutura de arquivos
ls -la

# 3. Torne o script executável
chmod +x update-changelog.sh

# 4. Verifique se existem arquivos auxiliares
ls -la scripts/
```

### Permissões Necessárias
- Permissão de leitura/escrita no arquivo CHANGELOG.md
- Acesso ao repositório git (se aplicável)

---

## 🎯 Modos de Execução

### Modo 1: Atualização Interativa
Adicione entradas manualmente com prompts guiados.

```bash
./update-changelog.sh
```

### Modo 2: Atualização Automática
Lê commits recentes e gera changelog automaticamente.

```bash
./update-changelog.sh --auto
```

---

## 📝 Exemplos de Uso

### Exemplo 1: Adicionar Nova Entrada
```bash
./update-changelog.sh

# Responda aos prompts:
# Versão: 1.2.0
# Tipo (feat/fix/docs/refactor): feat
# Descrição: Nova funcionalidade de autenticação
```

### Exemplo 2: Atualizar Automático com Git
```bash
./update-changelog.sh --auto
# Detecta commits e popula changelog automaticamente
```

---

## 🔧 Funções e Comportamento

### Sistema de Cores
- 🟢 **Verde**: Sucesso
- 🔵 **Azul**: Informações
- 🟡 **Amarelo**: Avisos
- 🔴 **Vermelho**: Erros

### Tratamento de Erros
- Valida formato do CHANGELOG.md
- Verifica permissões de arquivo
- Confirma operações antes de salvar

---

## ❗ Solução de Problemas

### Problema: "Permissão negada"
```bash
chmod +x update-changelog.sh
```

### Problema: "CHANGELOG.md não encontrado"
Crie o arquivo antes de executar:
```bash
touch CHANGELOG.md
```

---

## 🔄 Executar Novamente

É seguro executar múltiplas vezes. O script:
- Valida entradas duplicadas
- Mantém histórico intacto
- Atualiza apenas seções necessárias

---

## 📌 Notas Importantes

1. Mantenha o CHANGELOG atualizado a cada versão
2. Siga o padrão Semantic Versioning
3. Use tipos padrão: feat, fix, docs, refactor, perf

---

## 📞 Comandos Úteis Pós-Instalação

```bash
# Visualizar changelog
cat CHANGELOG.md

# Últimas 20 linhas
tail -20 CHANGELOG.md
```
