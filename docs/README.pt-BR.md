# Claimer Control

<p align="center">
  <strong>Seus jogos gratuitos e recompensas diárias em um painel local e privado.</strong><br>
  Instale uma vez, escolha as lojas e deixe o Claimer Control cuidar da rotina.
</p>

<p align="center">
  <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/actions/workflows/release.yml"><img alt="Testes" src="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/actions/workflows/release.yml/badge.svg"></a>
  <a href="../LICENSE"><img alt="Licença AGPL-3.0" src="https://img.shields.io/github/license/rafaelcairess/free-games-claimer-remaster-gui?style=flat-square"></a>
  <img alt="Windows 10 e 11" src="https://img.shields.io/badge/Windows-10%20%7C%2011-5aa7d9?style=flat-square">
  <img alt="Dados locais" src="https://img.shields.io/badge/dados-somente%20locais-6ee1b6?style=flat-square">
  <img alt="Idiomas" src="https://img.shields.io/badge/idiomas-EN%20%7C%20PT--BR%20%7C%20ES-bde6fb?style=flat-square">
</p>

<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.pt-BR.md">Português do Brasil</a> ·
  <a href="./README.es.md">Español</a>
</p>

<p align="center">
  <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases"><strong>Baixar o Claimer Control para Windows</strong></a>
</p>

> [!NOTE]
> O instalador para Windows estará disponível na página de Releases com a versão `v1.0.0`. Até essa publicação, este repositório contém a versão de desenvolvimento.

![Painel do Claimer Control mostrando jogos e resultados do AliExpress](images/05-dashboard.png)

## O que ele faz

- Resgata jogos, recursos e recompensas elegíveis nas lojas selecionadas.
- Coleta a recompensa diária do AliExpress e mostra moedas, saldo e sequência.
- Informa o resultado real de cada execução, não apenas uma contagem genérica.
- Executa por agendamento e pode iniciar automaticamente com o Windows.
- Abre um navegador visual quando uma loja exige login ou confirmação manual.
- Mantém painel, configurações, banco e sessões do navegador no seu computador.

## Serviços compatíveis

| Jogos e recursos | Recompensas e descoberta |
|---|---|
| Epic Games, Steam, GOG, Prime Gaming, Ubisoft, Fab e Unity Asset Store | Moedas diárias do AliExpress e descoberta de promoções pelo GamerPower |

O GamerPower também pode encaminhar promoções compatíveis do Fanatical, itch.io e IndieGala. A disponibilidade e os requisitos de login dependem de cada loja.

## Instale em três passos

1. Baixe `Claimer-Control-Setup.exe` na [Release mais recente](https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases).
2. Execute o instalador. Se o Docker Desktop não estiver presente, o launcher explica por que ele é necessário e só instala pela fonte oficial após sua confirmação.
3. Siga o assistente local: escolha o idioma e as lojas, adicione credenciais se desejar e defina o agendamento.

Pronto. Você não precisa clonar o repositório, editar arquivos de configuração ou digitar comandos Docker.

O instalador pode solicitar permissão de administrador ou uma reinicialização durante a instalação do Docker Desktop. Como o primeiro instalador não será assinado, o Windows SmartScreen poderá mostrar um aviso de editor desconhecido. Cada Release inclui `SHA256SUMS.txt` para verificar o download.

## Seus dados ficam no seu computador

O Claimer Control não possui servidor de contas e não inclui telemetria.

| O que acontece | Onde acontece |
|---|---|
| Painel e configurações | Em `127.0.0.1`, acessível somente neste computador |
| Credenciais e sessões | No volume Docker local |
| Login nas lojas | Diretamente entre o navegador automatizado e o site oficial da loja |
| Resposta da API sobre segredos | Somente `configured: true/false`; a senha nunca retorna ao painel |
| Atualizações | Consultadas nas Releases oficiais deste projeto no GitHub |

As credenciais são opcionais e o login manual pelo navegador está sempre disponível. Os segredos locais não são protegidos por um servidor externo de criptografia; mantenha sua conta do Windows e o disco protegidos. O Claimer Control não tenta contornar CAPTCHA, sistemas antifraude ou desafios de segurança.

## Feito para ser claro

Somente as lojas habilitadas aparecem no painel. Cada linha informa o que aconteceu: qual jogo foi resgatado, qual já estava na biblioteca, se não havia promoção ou quantas moedas do AliExpress foram coletadas.

| Configuração guiada da conta | Detalhes das moedas do AliExpress |
|---|---|
| ![Campo de credencial com explicação de privacidade](images/04-credentials.png) | ![Moedas diárias, saldo e sequência do AliExpress](images/06-aliexpress.png) |

Cada credencial possui uma explicação acessível no botão `?`. A interface funciona com mouse, teclado e toque e está traduzida integralmente para inglês, português do Brasil e espanhol.

## Uso diário

- Abra o **Claimer Control** pelo menu Iniciar ou pelo atalho da área de trabalho.
- Use **Executar agora** para todas as lojas ou execute somente uma delas.
- Use **Navegador** quando uma loja solicitar login, CAPTCHA ou confirmação manual.
- Use **Configurações** para alterar lojas, contas, notificações e agendamento.
- As atualizações são oferecidas no painel e preservam o volume local.

O launcher verifica o Docker, inicia o serviço, espera o painel responder e o abre automaticamente. A desinstalação mantém contas e sessões por padrão; apagar os dados locais é uma opção separada e explícita. O Docker Desktop nunca é removido automaticamente.

## Precisa de ajuda?

| Problema | O que fazer |
|---|---|
| O painel não abriu | Abra [http://127.0.0.1:8080](http://127.0.0.1:8080) e confirme que o Docker Desktop está em execução. |
| Uma loja precisa de atenção | Abra o navegador visual pelo painel e conclua a solicitação oficial da loja. |
| Uma sessão expirou | Entre novamente pelo navegador visual; a sessão atualizada permanecerá local. |
| Um resgate falhou | Tente executar somente aquela loja e anexe o trecho relevante do log sanitizado ao abrir uma issue. |

Para relatar bugs ou sugerir recursos, use as [Issues do GitHub](https://github.com/rafaelcairess/free-games-claimer-remaster-gui/issues). Nunca publique senhas, cookies, chaves TOTP, capturas completas de rede ou imagens sem sanitização.

## Para contribuidores

O instalador é o caminho recomendado para usuários. Builds pelo código-fonte, arquitetura e variáveis internas são assuntos para desenvolvimento:

- [`.env.example`](../.env.example) — referência completa para builds pelo código-fonte
- [`MODIFICATIONS.md`](../MODIFICATIONS.md) — histórico da implementação e diferenças técnicas
- [`CHANGELOG.md`](../CHANGELOG.md) — mudanças de cada versão

A suíte cobre módulos das lojas, API local, proteção de segredos, traduções, configuração inicial e launcher do Windows.

## Créditos e licença

**Interface e distribuição Windows do Claimer Control:** [Rafael Caires](https://github.com/rafaelcairess).

Construído sobre [P-Adamiec/Free-Games-Claimer-Remaster](https://github.com/P-Adamiec/Free-Games-Claimer-Remaster), mantido por Paweł Adamiec e seus contribuidores. Esse projeto foi inspirado em [vogler/free-games-claimer](https://github.com/vogler/free-games-claimer). Os avisos de terceiros estão em [`THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md).

Distribuído sob a [GNU Affero General Public License v3.0](../LICENSE).
