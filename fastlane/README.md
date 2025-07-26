# Fastlane Setup

## Configuração Inicial

1. **Instalar dependências**:
   ```bash
   bundle install
   ```

2. **Configurar variáveis de ambiente**:
   - Copie o arquivo `.env.example` para `.env`
   - Preencha as variáveis com seus valores reais
     - Melhor prática: Definir esses valores como secrets do repositório para serem utilizados pelo workflow.
   - Baixe sua API Key do App Store Connect e coloque na raiz do projeto
     - Melhor prática: Definir esses valores como secrets do repositório para serem utilizados pelo workflow.

3. **Configurar Appfile**:
   - Edite o arquivo `fastlane/Appfile` com seus dados:
     - `apple_id`: Seu email da Apple
     - `itc_team_id`: Team ID do App Store Connect
     - `team_id`: Team ID do Developer Portal

## Lanes Disponíveis

### 🧪 Tests
```bash
bundle exec fastlane tests
```
Executa todos os testes do projeto.

### 🔒 Sync Certificates
```bash
bundle exec fastlane sync_certificates
```
Sincroniza certificados e perfis de provisionamento. Se executado em CI, automaticamente configura o ambiente.

### 🔨 Build
```bash
bundle exec fastlane build
```
Gera o build do app para App Store (inclui sync de certificados).

### 🚀 Delivery
```bash
bundle exec fastlane delivery
```
Faz build e upload para App Store Connect (não submete para review automaticamente).

## Configuração de CI

Para usar em CI, a variável de ambiente `CI=true` é definida nas principais ferramentas (Github, Gitlab, Bitrise, etc). Isso fará com que o `setup_ci` seja executado automaticamente durante o sync de certificados.

## Variáveis de Ambiente Necessárias

- `APP_STORE_CONNECT_API_KEY_ID`: ID da sua API Key
- `APP_STORE_CONNECT_ISSUER_ID`: Issuer ID da sua API Key  
- `APP_STORE_CONNECT_API_KEY_PATH`: Caminho para o arquivo .p8 da API Key
- `MATCH_GIT_URL`: URL do repositório Git para Match (opcional)
- `MATCH_PASSWORD`: Senha para Match (opcional)
