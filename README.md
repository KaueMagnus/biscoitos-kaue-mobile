# Biscoitos Kauê Mobile

Aplicativo mobile do sistema **Biscoitos Kauê**, desenvolvido em Flutter para representantes comerciais realizarem pedidos de produtos de forma digital.

Este projeto faz parte do Projeto de Desenvolvimento de Software do curso de Análise e Desenvolvimento de Sistemas.

---

## Sobre o projeto

A empresa Biscoitos Kauê possui representantes comerciais que atendem clientes e registram pedidos de produtos. O aplicativo mobile foi desenvolvido para facilitar esse processo, permitindo que o representante cadastre clientes, consulte produtos, crie pedidos normais ou de troca e acompanhe o histórico de pedidos diretamente pelo celular.

A solução completa é composta por:

* **Mobile:** aplicativo Flutter para representantes comerciais;
* **Backend:** API REST em Java com Spring Boot;
* **Web:** painel administrativo em React;
* **Banco de dados:** PostgreSQL;
* **Ambiente online de homologação:** backend publicado no Render, banco PostgreSQL no Neon, painel web na Vercel e envio de e-mails pelo Resend.

---

## Funcionalidades do aplicativo

* Login de representantes;
* Armazenamento de token JWT;
* Logout;
* Cadastro de clientes;
* Listagem de clientes;
* Busca de clientes;
* Listagem de produtos;
* Busca de produtos;
* Criação de pedido normal;
* Criação de pedido de troca;
* Campo digitável para quantidade de produtos;
* Histórico/listagem de pedidos;
* Filtros de pedidos;
* Detalhe do pedido;
* Exibição de status do pedido;
* Feedback visual com mensagens padronizadas;
* Tratamento de erros de API;
* Configuração de timeout para ambiente online;
* Formatação monetária em padrão brasileiro;
* Identidade visual da Biscoitos Kauê;
* Nome, ícone e splash screen personalizados.

---

## Tecnologias utilizadas

* Flutter
* Dart
* Dio
* Provider
* SharedPreferences
* Material Design
* Android Studio
* Android Emulator ou dispositivo físico

---

## Integração com o backend

O aplicativo consome a API backend do sistema Biscoitos Kauê.

Durante o desenvolvimento local com Android Emulator, a URL da API deve usar:

```text
http://10.0.2.2:8080
```

No Android Emulator, `localhost` aponta para o próprio emulador. Por isso, para acessar o backend rodando na máquina local, é necessário usar `10.0.2.2`.

Para o ambiente online de homologação, o aplicativo deve consumir a API publicada no Render:

```text
https://biscoitos-kaue-backend.onrender.com
```

A URL da API pode ser definida no momento da geração do APK por meio da variável `API_BASE_URL`.

---

## Ambiente de homologação online

O aplicativo foi validado em ambiente online de homologação, consumindo a API backend hospedada no Render e integrada ao banco PostgreSQL no Neon.

Itens utilizados na homologação:

* **Backend:** Render
* **Banco de dados:** Neon PostgreSQL
* **Painel web:** Vercel
* **Envio de e-mail:** Resend
* **Aplicativo mobile:** APK Android configurado para consumir a API online

Este ambiente tem finalidade acadêmica e de demonstração, não representando uma implantação em produção real da empresa.

---

## Pré-requisitos

Antes de rodar o projeto, é necessário ter instalado:

* Flutter SDK;
* Dart;
* Android Studio;
* Android Emulator ou dispositivo físico;
* Backend do projeto rodando localmente ou API online disponível.

---

## Como rodar o projeto localmente

Clone o repositório:

```bash
git clone https://github.com/KaueMagnus/biscoitos-kaue-mobile.git
```

Acesse a pasta do projeto:

```bash
cd biscoitos-kaue-mobile
```

Instale as dependências:

```bash
flutter pub get
```

Rode o aplicativo em ambiente local:

```bash
flutter run
```

Por padrão, o aplicativo pode ser executado apontando para:

```text
http://10.0.2.2:8080
```

---

## Como rodar apontando para a API online

Para executar o aplicativo apontando para a API online de homologação:

```bash
flutter run --dart-define=API_BASE_URL=https://biscoitos-kaue-backend.onrender.com
```

---

## Como gerar o APK

Para gerar o APK de release em ambiente local:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

Para gerar o APK de homologação apontando para a API online:

```bash
flutter clean
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://biscoitos-kaue-backend.onrender.com
```

O APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## APK de homologação

O APK de homologação foi gerado para permitir testes em dispositivo Android sem necessidade de executar o projeto localmente.

Link para download:

[Baixar APK do aplicativo mobile](https://drive.google.com/file/d/1AYGlK3rkz0xZrCHLfP76-dT7p7OwhFVs/view?usp=sharing)

Para instalar:

1. Baixe o arquivo APK no dispositivo Android.
2. Permita a instalação de aplicativos de fontes externas, caso o Android solicite.
3. Instale o aplicativo.
4. Abra o app e realize login com o usuário de teste.
5. Crie um pedido normal ou de troca.
6. Consulte o histórico do pedido no aplicativo.
7. Confira o pedido no painel administrativo web.

---

## Fluxo principal do aplicativo

1. O representante abre o aplicativo.
2. Faz login com suas credenciais.
3. Acessa o menu principal.
4. Consulta ou cadastra clientes.
5. Consulta produtos disponíveis.
6. Cria um pedido normal ou de troca.
7. Informa as quantidades dos produtos.
8. Envia o pedido para a API backend.
9. Recebe uma mensagem de sucesso.
10. Acompanha o pedido no histórico.
11. O pedido fica disponível para acompanhamento no painel administrativo web.

---

## Tipos de pedido

O aplicativo permite criar dois tipos de pedido:

```text
NORMAL
TROCA
```

Em pedidos de troca, o representante deve informar o motivo da troca.

---

## Status de pedido

Os pedidos podem possuir os seguintes status:

```text
PENDENTE
ENVIADO
CANCELADO
```

Esses status são atualizados pelo painel administrativo web e exibidos no aplicativo.

---

## Identidade visual

O aplicativo utiliza a identidade visual da Biscoitos Kauê, com:

* logo oficial;
* tela de login personalizada;
* splash screen personalizada;
* ícone do aplicativo;
* cores da marca;
* cards e botões padronizados;
* mensagens de feedback personalizadas.

---

## Usuário de teste

Usuário representante utilizado para testes:

```text
REPRESENTANTE
E-mail: representante@biscoitoskaue.com
Senha: 123456
```

Observação: os usuários podem variar conforme os dados cadastrados no backend.

---

## Painel administrativo

O pedido criado pelo aplicativo pode ser acompanhado no painel administrativo web:

```text
https://biscoitos-kaue-web.vercel.app/login
```

Usuário administrador utilizado para testes:

```text
ADMIN
E-mail: admin@biscoitoskaue.com
Senha: 123456
```

---

## Links importantes

Backend:

```text
https://github.com/KaueMagnus/biscoitos-kaue-backend
```

Mobile:

```text
https://github.com/KaueMagnus/biscoitos-kaue-mobile
```

Web:

```text
https://github.com/KaueMagnus/biscoitos-kaue-web
```

API online de homologação:

```text
https://biscoitos-kaue-backend.onrender.com
```

Painel web online:

```text
https://biscoitos-kaue-web.vercel.app/login
```

APK:

[Baixar APK do aplicativo mobile](https://drive.google.com/file/d/1H6BKzXM1XJhrsThZPU9eXw8oMcPUGkhT/view?usp=sharing)

---

## Autor

Desenvolvido por **Kaue Marques Magnus**.

Projeto desenvolvido para a disciplina de Projeto de Desenvolvimento de Software do curso de Análise e Desenvolvimento de Sistemas.

---

## Licença

Projeto acadêmico desenvolvido para fins educacionais.
