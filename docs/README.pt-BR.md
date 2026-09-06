# Claimer Control

<p align="center">
  <strong>Um painel local que coleta jogos gratuitos e as moedas diárias do AliExpress para você.</strong><br>
  <sub>O painel, as contas e as sessões do navegador permanecem no seu computador.</sub>
</p>

<p align="center">
  <a href="../README.md">English</a> ·
  <strong>Português do Brasil</strong> ·
  <a href="./README.es.md">Español</a>
</p>

<p align="center">
  <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases/latest/download/Claimer-Control-Setup.exe"><strong>Baixar para Windows</strong></a>
  · <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases/latest">Notas da versão e SHA-256</a>
</p>

> [!IMPORTANT]
> O Claimer Control não mantém servidor de credenciais e não possui telemetria. Os dados informados no painel ficam no volume Docker local e são enviados somente pelo navegador automatizado ao login oficial de cada loja.

Mantido por [Rafael Caires](https://github.com/rafaelcairess), com base no [Free Games Claimer Remaster](https://github.com/P-Adamiec/Free-Games-Claimer-Remaster) de Paweł Adamiec. A autoria original e a licença AGPL-3.0 estão preservadas.

## O que ele faz

- Mostra as lojas escolhidas, execução atual, próximo horário e resultados reais.
- Informa o nome de cada jogo verificado e se foi resgatado, já existia ou falhou.
- Mostra moedas coletadas, saldo, sequência de dias e próxima recompensa do AliExpress quando a API oferece esses dados.
- Executa todas as lojas ou apenas uma.
- Abre o navegador visual para login manual, 2FA e desafios de segurança.
- Configura lojas, contas, agendamento e notificações sem editar arquivos.
- Detecta português, inglês ou espanhol e permite troca manual.
- Avisa quando existe atualização, mas só instala após sua confirmação.

Lojas principais: Steam, Epic Games, Fab, Prime Gaming, GOG, Ubisoft, Unity Asset Store, AliExpress e fontes extras do GamerPower.

## Instalação no Windows

1. Baixe o **[Claimer-Control-Setup.exe](https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases/latest/download/Claimer-Control-Setup.exe)** da Release mais recente.
2. Execute o instalador. Se o Docker Desktop estiver ausente, o Claimer Control explica o motivo e pede autorização para instalá-lo pela fonte oficial.
3. O painel abrirá automaticamente. Siga o assistente para escolher idioma, lojas, contas opcionais e agendamento.

A instalação do Docker pode solicitar administrador e reinicialização. O Claimer Control retoma a configuração após entrar no Windows. Como o instalador ainda não possui certificado de assinatura, o SmartScreen pode mostrar “Editor desconhecido”. Compare o arquivo com `SHA256SUMS.txt` da mesma Release.

O atalho inicia o Docker quando necessário, baixa a imagem correta, sobe o container e abre `http://localhost:8080`. Não é necessário usar PowerShell manualmente.

## Primeiro uso

O assistente possui seis passos:

1. idioma detectado pelo Windows/navegador;
2. explicação de segurança;
3. lojas que aparecerão e serão automatizadas;
4. credenciais opcionais;
5. intervalo, horários e execução ao iniciar;
6. revisão e primeira execução.

Deixe qualquer conta vazia se preferir login manual. Clique em **Navegador** e entre diretamente na loja pela sessão visual local. Cookies e sessões ficam no volume Docker e são reutilizados nas próximas execuções.

## Segurança e credenciais

| Pergunta | Resposta |
|---|---|
| Rafael ou o Claimer Control recebem minhas senhas? | Não. Não existe servidor nosso recebendo os dados do painel. |
| Onde ficam as credenciais? | No arquivo `gui.env`, dentro do volume Docker local, com permissão restrita. |
| A senha sai do computador? | Somente para o navegador automatizado enviá-la diretamente ao login oficial da loja, como qualquer navegador precisa fazer. |
| O painel consegue mostrar a senha salva? | Não. A API informa apenas se o campo já está configurado. |
| O painel fica disponível na internet? | Não. A porta usa `127.0.0.1` por padrão. Não exponha a porta 8080. |
| Existe telemetria? | Não. As conexões externas são lojas, notificações configuradas e busca de atualizações. |

O botão `?` ao lado de cada credencial explica para qual loja o dado será usado. Senhas e sessões locais continuam sendo informações sensíveis: proteja sua conta do Windows e o disco do computador.

## Imagens do produto

Todas as capturas usam contas sintéticas e resultados de demonstração.

| Configuração inicial | Segurança local |
|---|---|
| ![Escolha de idioma](images/01-language.png) | ![Explicação de segurança](images/02-security.png) |

| Lojas | Credenciais |
|---|---|
| ![Seleção de lojas](images/03-stores.png) | ![Ajuda de credencial](images/04-credentials.png) |

| Painel | Moedas do AliExpress |
|---|---|
| ![Resultados de jogos](images/05-dashboard.png) | ![Saldo e sequência do AliExpress](images/06-aliexpress.png) |

| Agendamento | Login manual |
|---|---|
| ![Configuração do agendamento](images/07-schedule.png) | ![Navegador visual local](images/08-browser.png) |

## Automação e atualizações

- Intervalo padrão: 12 horas.
- É possível usar horários fixos no fuso escolhido, combinar os dois modos ou executar apenas manualmente.
- A opção de iniciar com o Windows vem marcada no instalador, mas pode ser desativada.
- O painel consulta a Release oficial e apresenta **Ver atualização**. Ao confirmar, o launcher local troca somente a imagem do aplicativo e preserva o volume.
- Desinstalar preserva contas, histórico e sessões por padrão. A exclusão desses dados exige uma confirmação separada.
- O desinstalador nunca remove o Docker Desktop.

## Instalação manual

Para Linux, NAS ou desenvolvimento:

```bash
git clone https://github.com/rafaelcairess/free-games-claimer-remaster-gui.git
cd free-games-claimer-remaster-gui
cp .env.example .env
docker compose up -d
```

Painel: `http://localhost:8080`  
Navegador visual: `http://localhost:7080`  
Logs: `docker logs -f fgc-remaster`

As opções avançadas e todas as variáveis estão na [referência principal](../README.md#configuration) e no arquivo [`.env.example`](../.env.example).

## Solução de problemas

| Problema | Solução |
|---|---|
| Docker não inicia | Abra o Docker Desktop, conclua as telas iniciais e execute novamente o atalho. |
| Loja pede 2FA ou CAPTCHA | Abra **Navegador** e conclua manualmente. O projeto não tenta burlar desafios de segurança. |
| Painel não abre | Confirme se o container `claimer-control` está ativo no Docker Desktop. |
| Login não persiste | Verifique se o volume `claimer-control-data` existe e não foi apagado. |
| Atualização não abre | Execute o atalho do menu Iniciar e tente novamente; o protocolo local pode exigir confirmação do navegador. |

## Licença e créditos

Interface e distribuição Claimer Control por [Rafael Caires](https://github.com/rafaelcairess). Motor baseado no projeto de [Paweł Adamiec](https://github.com/P-Adamiec/Free-Games-Claimer-Remaster) e seus contribuidores, inspirado no projeto Node.js de [vogler](https://github.com/vogler/free-games-claimer). Licença [AGPL-3.0](../LICENSE).
