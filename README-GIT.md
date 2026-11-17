# Projeto — pacote pronto para Git

Este pacote preserva o código da aplicação e os assets existentes. As dependências instaláveis foram deixadas fora do repositório para serem reconstruídas pelos lockfiles.

## Requisitos
- PHP 8.1 ou superior e extensões exigidas pelo `composer.json`
- Composer
- Node.js e npm
- Banco de dados compatível com a configuração Laravel

## Preparação local
1. Copie `.env.example` para `.env` e preencha as credenciais do seu ambiente.
2. Execute `composer install`.
3. Execute `npm ci`.
4. Execute `php artisan key:generate`.
5. Execute `php artisan storage:link` somente se seu deploy usar o link padrão do Laravel e o caminho ainda não existir.
6. Execute `npm run build`.

Não publique `.env`, credenciais, chaves privadas ou backups de configuração.

## Observação
`vendor/` foi omitido porque é reconstruível por `composer install` e `composer.lock`. Arquivos de `public/storage/` foram preservados como assets do projeto e removidos da regra de exclusão do Git.
