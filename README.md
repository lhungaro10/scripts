# 🚀 Scripts para facilitar a vida do programador

Este repositório é dedicado à criação de scripts para facilitar a execução de tarefas diárias do programador e otimização do tempo. Automação de ambientes, configurações e processos repetitivos para desenvolvedores.

---

## 📦 Scripts Disponíveis

### 🐧 Debian 13 Setup Orchestrator
**Localização**: `setup-debian/`

Script completo de automação para configuração de ambiente de desenvolvimento no Debian 13.

**Características:**
- ✅ Instalação modular ou completa
- ✅ 6 módulos independentes (Git, Docker, Java, VS Code, Zsh, Dependências)
- ✅ Interface interativa com seleção de componentes
- ✅ Tratamento de erros e confirmações
- ✅ Execução segura e idempotente

**Quick Start:**
```bash
cd setup-debian
./setup.sh
```

📖 [Documentação completa](setup-debian/INSTRUCTIONS.md)

### 🛠️ Dev Utils - Update Changelog
**Localização**: `dev-utils/update-changelog/`

Script para gerenciar e manter arquivos CHANGELOG.md de forma padronizada e automatizada.

**Características:**
- ✅ Atualização automática de versões (major, minor, patch)
- ✅ Organização por categorias (Added, Changed, Fixed, Removed)
- ✅ Compatível com Keep a Changelog e Semantic Versioning
- ✅ Interface interativa para adicionar entradas
- ✅ Preserva histórico completo

**Quick Start:**
```bash
cd dev-utils/update-changelog
./update-changelog.sh /path/to/CHANGELOG.md [major|minor|patch]
```

📖 [Documentação completa](dev-utils/update-changelog/INSTRUCTIONS.md)

---

## 📂 Estrutura do Projeto

```
scripts/
├── README.md                          # Este arquivo
│
├── setup-debian/                      # Setup automatizado Debian 13
│   ├── setup.sh                       # Orquestrador principal
│   ├── CHANGELOG.md                   # Histórico de mudanças
│   ├── INSTRUCTIONS.md                # Instruções detalhadas
│   └── scripts/
│       ├── utils.sh                   # Funções auxiliares
│       ├── install_dependencies.sh    # Dependências do sistema
│       ├── setup_git.sh               # Configuração Git/SSH
│       ├── setup_zsh.sh               # Terminal Zsh + Oh My Zsh
│       ├── setup_docker.sh            # Docker Engine
│       ├── setup_java.sh              # Java 17 LTS
│       └── setup_vscode.sh            # VS Code + extensões
│
└── dev-utils/                         # Utilitários de desenvolvimento
    ├── README.md                      # Overview
    └── update-changelog/              # Gerenciador de CHANGELOG
        ├── update-changelog.sh        # Script principal
        └── INSTRUCTIONS.md            # Instruções
```

---

## 🎯 Filosofia do Projeto

Este repositório segue os princípios:

1. **Modularidade**: Scripts independentes que podem ser executados separadamente
2. **Idempotência**: Seguro para executar múltiplas vezes
3. **Interatividade**: Usuário tem controle sobre o que instalar
4. **Documentação**: Cada script possui instruções claras
5. **Compatibilidade**: Testado em ambientes Linux (Debian/Ubuntu)

---

## 🛠️ Tecnologias e Ferramentas

Os scripts deste repositório trabalham com:

- **Shells**: Bash, Zsh
- **Containerização**: Docker, Docker Compose
- **Linguagens**: Java (OpenJDK 17)
- **Editores**: Visual Studio Code
- **Versionamento**: Git, SSH
- **Terminal**: Oh My Zsh, Starship

---

## 🚀 Como Usar

### 1. Clone o Repositório
```bash
git clone <url-do-repositorio>
cd scripts
```

### 2. Escolha o Script Desejado
```bash
# Listar scripts disponíveis
ls -la

# Acessar diretório específico
cd setup-debian
```

### 3. Siga a Documentação
Cada script possui seu próprio arquivo de instruções (`INSTRUCTIONS.md` ou `README.md`)

### 4. Execute com Permissões Adequadas
```bash
chmod +x setup.sh
./setup.sh
```

---

## 🤝 Como Contribuir

Contribuições são bem-vindas! Siga estas diretrizes:

### Adicionar Novo Script

1. **Crie um diretório** para seu script
   ```bash
   mkdir nome-do-script
   cd nome-do-script
   ```

2. **Estruture adequadamente**
   ```
   nome-do-script/
   ├── README.md          # Overview
   ├── INSTRUCTIONS.md    # Instruções detalhadas
   ├── script.sh          # Script principal
   └── modules/           # Scripts auxiliares (opcional)
   ```

3. **Documente**
   - Propósito e funcionalidades
   - Pré-requisitos
   - Exemplos de uso
   - Solução de problemas

4. **Teste**
   - Execute em ambiente limpo
   - Verifique idempotência
   - Teste tratamento de erros

5. **Atualize o README principal**
   - Adicione na seção "Scripts Disponíveis"
   - Atualize a estrutura do projeto

### Pull Requests

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Add: novo script de automação'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

---

## 🐛 Reportar Problemas

Encontrou um bug ou tem uma sugestão?

1. Verifique se já não existe uma issue aberta
2. Crie uma nova issue com:
   - Descrição clara do problema
   - Sistema operacional e versão
   - Passos para reproduzir
   - Logs de erro (se aplicável)

---

## 📜 Licença

Este projeto está sob licença livre. Sinta-se à vontade para usar, modificar e distribuir.

---

## 👥 Colaboradores

Desenvolvido e mantido por desenvolvedores que valorizam automação e eficiência.

**Quer ser um colaborador?** Faça sua primeira contribuição! 🎉

---

## 📞 Links Úteis

- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/)
- [Docker Documentation](https://docs.docker.com/)
- [VS Code Documentation](https://code.visualstudio.com/docs)
- [Oh My Zsh](https://ohmyz.sh/)

---

**⭐ Se este projeto te ajudou, considere dar uma estrela!**

*Última atualização: 29 de Dezembro de 2025*