# Pro Ticket — infraestrutura (Docker / Railway)

Repositório público com **Docker Compose** para desenvolvimento local e **Dockerfile** mínimo que referencia a imagem do bot publicada no [GitHub Container Registry](https://github.com/users/jorgehenrrique/packages/container/package/pro-ticket-bot). O uso da **imagem** do Pro Ticket está sujeito ao [EULA](EULA.md).

A **versão do bot** alinhada com a imagem `ghcr.io/jorgehenrrique/pro-ticket-bot` está no ficheiro [**VERSION**](VERSION).

## Deploy com um clique (Railway)

**Template oficial:**

[![Deploy Pro Ticket Discord Bot](https://railway.com/button.svg)](https://railway.com/deploy/pro-ticket-discord-bot)

Após o deploy, siga o fluxo de OAuth no Discord (redirect para o painel web) e use `/start` no servidor, como descrito na página do template.

---

## Desenvolvimento local (`docker compose`)

1. Copie as variáveis de ambiente:

   ```bash
   cp .env.example .env
   ```

2. Edite `.env`: defina pelo menos `BOT_TOKEN`, `GUILD_ID`, `DISCORD_CLIENT_SECRET` e ajuste `BASE_URL` para `http://localhost:8080` (e `SERVER_HOSTNAME` para `localhost` se usar funcionalidades que dependam de hostname).

3. Suba MongoDB + bot (requer Docker Compose com suporte a `env_file` opcional; em versões antigas, o ficheiro `.env` tem de existir mesmo vazio):

   ```bash
   docker compose up -d
   ```

4. Abra `http://localhost:8080` para o painel web.

O `docker-compose.yml` inclui **MongoDB 8** oficial só para uso local. Os valores `root` / `changeme` devem coincidir com `MONGO_URI` no `.env` (já pré-preenchido no `.env.example`).

---

## Railway: MongoDB gerenciado + bot a partir deste repositório

A Railway **não executa** o ficheiro `docker-compose.yml` como um único stack a partir do Git; cada serviço do projeto é configurado no dashboard (ou importado a partir de um compose como _referência_). Para produção recomenda-se:

1. **MongoDB** — adicionar o plugin **Database → MongoDB** ao projeto.
2. **Bot** — novo serviço → **GitHub** → selecionar **este** repositório; a Railway deteta o `Dockerfile` na raiz e constrói a imagem a partir de `FROM ghcr.io/jorgehenrrique/pro-ticket-bot:latest`.

### Variáveis no serviço do bot

| Variável                     | Obrigatória | Descrição                                                                                                                                                                 |
| ---------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `BOT_TOKEN`                  | Sim         | Token do bot (Discord Developer Portal).                                                                                                                                  |
| `GUILD_ID`                   | Sim         | ID do servidor Discord.                                                                                                                                                   |
| `DISCORD_CLIENT_SECRET`      | Sim\*       | Client Secret OAuth2 (necessário para login no painel web).                                                                                                               |
| `MONGO_URI`                  | Sim         | URI de ligação ao MongoDB. Use **referência** ao serviço MongoDB (`${{Mongo.MONGO_URL}}` ou o nome que o template expuser — o dashboard mostra o nome exato da variável). |
| `MONGO_DB_TICKET`            | Sim         | Nome da base (ex.: `pro_ticket`).                                                                                                                                         |
| `COLLECTION_SYSTEM_SETTINGS` | Sim         | Nome da coleção (ex.: `system_settings`).                                                                                                                                 |
| `COLLECTION_VERIFIED_USERS`  | Sim         | Ex.: `verified_users`.                                                                                                                                                    |
| `COLLECTION_TICKETS`         | Sim         | Ex.: `tickets`.                                                                                                                                                           |
| `COLLECTION_TICKET_USERS`    | Sim         | Ex.: `ticket_users`.                                                                                                                                                      |
| `BASE_URL`                   | Sim         | URL pública HTTPS do serviço (ex.: `https://<domínio>.up.railway.app`).                                                                                                   |
| `PORT`                       | Recomendado | `8080` (deve coincidir com a porta exposta na **Networking**).                                                                                                            |
| `NODE_ENV`                   | Recomendado | `production`.                                                                                                                                                             |
| `SERVER_HOSTNAME`            | Opcional    | Útil em alguns cenários (ex.: domínio público sem `https://`).                                                                                                            |
| `STEAM_API_KEY`              | Opcional    | Steam — avatares na verificação.                                                                                                                                          |

\*Obrigatória para o fluxo OAuth do painel (`DISCORD_CLIENT_SECRET` validado no servidor ao iniciar login).

### OAuth2 — redirect do painel

No Discord Developer Portal → OAuth2 → Redirects, adicione:

`https://<SEU_DOMINIO_RAILWAY>/api/auth/discord/callback`

### Rede pública

Em **Settings → Networking**, gere domínio e defina o tráfego HTTP para a porta **8080** (como no template atual).

## Recursos do bot (resumo)

- **Runtime:** Node 20+, Discord.js 14, Express (API + painel React embutido na imagem), MongoDB.
- **Idiomas:** pt-BR, en-US, es-ES.
- **Painel web:** estatísticas, relatórios, configurações, OAuth Discord, rotas Steam e verificação.
- **Tickets:** abertura/fecho/finalização, painéis, servidores/tipos/tags, campos custom, convites, voz, transcripts, notificações, ratings mútuos, relatórios agendados, administração (`/ticketadm`, `/configt`, etc.).
- **Outros:** verificação Steam, mensagens de boas-vindas, canais de voz dinâmicos (`/autovoice`), temporizador (`/timer`), métricas, mensagens em massa, comandos de bot/status.

Lista detalhada de comandos slash e rotas: ver documentação no canal criado pelo bot ou na [página do template Railway](https://railway.com/deploy/pro-ticket-discord-bot).

## Licença

- **Este repositório** (Dockerfile, `docker-compose.yml`, exemplos de ambiente, workflows, documentação): [MIT License](LICENSE).
- **Imagem de contentor** `ghcr.io/jorgehenrrique/pro-ticket-bot`: não está coberta pela MIT deste repositório; aplica-se o [EULA — Pro Ticket (imagem)](EULA.md) (software proprietário, código-fonte não publicado).
