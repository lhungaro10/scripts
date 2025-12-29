# 🚀 Instruções de Uso - Debian 13 Setup Orchestrator

## 📋 Descrição

Script automatizado para configuração completa de um ambiente de desenvolvimento Debian 13. Permite instalação modular ou completa de ferramentas essenciais para desenvolvimento.

---

## ⚙️ Pré-requisitos

### Sistema Operacional
- **Debian 13** (Trixie) ou compatível
- Usuário com privilégios `sudo`
- Conexão ativa com a internet

### Antes de Executar
```bash
# 1. Clone ou baixe o projeto
cd ~/scripts/setup-debian

# 2. Verifique a estrutura de arquivos
ls -la

# 3. Torne o script principal executável
chmod +x setup.sh

# 4. Verifique se todos os módulos estão presentes
ls -la scripts/
```

### Permissões Necessárias
- Acesso root/sudo para instalação de pacotes
- Permissão de escrita no diretório home (~/)
- Acesso à internet para download de pacotes

---

## 📦 Módulos Disponíveis

O setup está organizado em 6 módulos independentes:

| Módulo | Script | Descrição | Essencial |
|--------|--------|-----------|-----------|
| **1** | `install_dependencies.sh` | Atualização do sistema e pacotes essenciais (curl, wget, git, build-essential, etc.) | ✅ Sim |
| **2** | `setup_git.sh` | Configuração do Git (user.name, user.email) e geração de chaves SSH | ⚪ Opcional |
| **3** | `setup_zsh.sh` | Instalação do Zsh, Oh My Zsh e Starship prompt | ⚪ Opcional |
| **4** | `setup_docker.sh` | Docker Engine e Docker Compose v2 | ⚪ Opcional |
| **5** | `setup_java.sh` | OpenJDK 17 LTS e configuração de JAVA_HOME | ⚪ Opcional |
| **6** | `setup_vscode.sh` | Visual Studio Code e extensões recomendadas | ⚪ Opcional |

---

## 🎯 Modos de Execução

### Modo 1: Instalação Completa (Recomendado)
Instala todos os módulos de uma vez.

```bash
./setup.sh
# Pressione ENTER quando perguntado sobre instalação completa
```

### Modo 2: Instalação Seletiva
Escolha individualmente quais módulos instalar.

```bash
./setup.sh
# Digite 'n' quando perguntado sobre instalação completa
# Responda S/n para cada módulo
```

---

## 📝 Exemplos de Uso

### Exemplo 1: Setup Completo (Primeira Instalação)
```bash
cd ~/scripts/setup-debian
./setup.sh

# Saída esperada:
# =========================================
#       Debian 13 Setup Orchestrator       
# =========================================
# 
# Deseja executar a instalação COMPLETA (todos os módulos)?
# Pressione [ENTER] para Sim ou 'n' para escolher manualmente: [PRESSIONE ENTER]
# 
# >> Modo Completo selecionado.
# 
# =========================================
# Resumo do que será executado:
#   -> scripts/install_dependencies.sh
#   -> scripts/setup_git.sh
#   -> scripts/setup_zsh.sh
#   -> scripts/setup_docker.sh
#   -> scripts/setup_java.sh
#   -> scripts/setup_vscode.sh
# =========================================
# 
# Confirma o início da configuração? (S/n): S
```

### Exemplo 2: Apenas Dependências + Docker
```bash
./setup.sh

# Pressione 'n' na primeira pergunta
# Responda:
# - Dependências do Sistema: S
# - Git & SSH: n
# - Zsh & Oh My Zsh: n
# - Docker: S
# - Java: n
# - VS Code: n
```

### Exemplo 3: Apenas Ferramentas de Desenvolvimento
```bash
./setup.sh

# Instalação seletiva:
# - Dependências: S (sempre recomendado)
# - Git: S
# - Zsh: S
# - Docker: n
# - Java: S
# - VS Code: S
```

---

## 🔧 Funções e Comportamento

### Sistema de Cores
O script utiliza cores para facilitar a leitura:
- 🟢 **Verde**: Sucesso, confirmações, arquivos executados
- 🔵 **Azul**: Cabeçalhos, títulos, separadores
- 🟡 **Amarelo**: Avisos, módulos pulados
- 🔴 **Vermelho**: Erros críticos

### Tratamento de Erros
- Se um módulo falhar, o script pergunta se deseja continuar
- Códigos de saída são verificados para cada módulo
- Possibilidade de abortar ou prosseguir após erro

### Verificações Automáticas
- Verifica existência do `utils.sh` antes de executar
- Valida presença de cada script módulo
- Garante permissões de execução automaticamente

---

## 📂 Estrutura de Arquivos

```
setup-debian/
├── setup.sh                      # Script principal (orchestrator)
├── INSTRUCTIONS.md               # Este arquivo
├── README.md                     # Documentação do projeto
└── scripts/
    ├── utils.sh                  # Funções auxiliares e cores
    ├── install_dependencies.sh   # Módulo 1: Dependências
    ├── setup_git.sh             # Módulo 2: Git
    ├── setup_zsh.sh             # Módulo 3: Zsh
    ├── setup_docker.sh          # Módulo 4: Docker
    ├── setup_java.sh            # Módulo 5: Java
    └── setup_vscode.sh          # Módulo 6: VS Code
```

---

## ❗ Solução de Problemas

### Problema: "Erro: utils.sh não encontrado"
**Solução**: Execute o script a partir do diretório correto
```bash
cd /home/hungaro/scripts/setup-debian
./setup.sh
```

### Problema: "Permissão negada"
**Solução**: Torne o script executável
```bash
chmod +x setup.sh
chmod +x scripts/*.sh
```

### Problema: Módulo falhou durante execução
**Resposta**: O script perguntará se deseja continuar
- Digite `S` para prosseguir com próximos módulos
- Digite `N` para abortar completamente

### Problema: Script não encontra módulos
**Solução**: Verifique a estrutura de diretórios
```bash
# Deve retornar todos os 7 arquivos .sh
ls -la scripts/*.sh
```

---

## 🔄 Executar Novamente

É seguro executar o script múltiplas vezes. Os módulos devem:
- Detectar se já estão instalados
- Pular etapas já concluídas
- Atualizar configurações quando necessário

```bash
# Para reinstalar apenas Docker e VS Code
./setup.sh
# Escolha modo manual e selecione apenas esses módulos
```

---

## 📌 Notas Importantes

1. **Primeira Execução**: Recomenda-se fazer backup do sistema antes
2. **Tempo de Instalação**: Completa leva ~15-30 minutos dependendo da internet
3. **Reinicialização**: Alguns módulos (Docker, Zsh) podem requerer logout/login
4. **Sudo**: Será solicitada senha durante a execução dos módulos

---

## 📞 Comandos Úteis Pós-Instalação

```bash
# Verificar versões instaladas
git --version
docker --version
java -version
code --version

# Testar Docker
docker run hello-world

# Verificar shell padrão (se instalou Zsh)
echo $SHELL

# Ver chaves SSH geradas (se instalou Git)
ls -la ~/.ssh/
```

---

## 📄 Licença e Contribuições

Este script é fornecido como está. Sinta-se livre para:
- Modificar os módulos conforme necessidade
- Adicionar novos módulos à lista
- Compartilhar melhorias

**Última atualização**: Dezembro 2025