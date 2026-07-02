# Biscoitos Kauê Mobile

Aplicativo mobile do sistema **Biscoitos Kauê**, desenvolvido em Flutter para representantes comerciais realizarem pedidos de produtos de forma digital.

Este projeto faz parte do Projeto de Desenvolvimento de Software do curso de Análise e Desenvolvimento de Sistemas.

---

## Sobre o projeto

A empresa Biscoitos Kauê possui representantes comerciais que atendem clientes e registram pedidos de produtos. O aplicativo mobile foi desenvolvido para facilitar esse processo, permitindo que o representante cadastre clientes, consulte produtos, crie pedidos e acompanhe o histórico de pedidos diretamente pelo celular.

A solução completa é composta por:

* **Mobile:** aplicativo Flutter para representantes comerciais;
* **Backend:** API REST em Java com Spring Boot;
* **Web:** painel administrativo em React;
* **Banco de dados:** PostgreSQL.

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
* Android Emulator

---

## Integração com o backend

O aplicativo consome a API backend do sistema Biscoitos Kauê.

Durante o desenvolvimento local com Android Emulator, a URL da API deve usar:

```text
http://10.0.2.2:8080
```

Observação:

No Android Emulator, `localhost` aponta para o próprio emulador. Por isso, para acessar o backend rodando na máquina local, é necessário usar `10.0.2.2`.

---

## Pré-requisitos

Antes de rodar o projeto, é necessário ter instalado:

* Flutter SDK;
* Dart;
* Android Studio;
* Android Emulator ou dispositivo físico;
* Backend do projeto rodando localmente.

---

## Como rodar o projeto

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

Rode o aplicativo:

```bash
flutter run
```

---

## Como gerar o APK

Para gerar o APK de release:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

O APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Fluxo principal do aplicativo

1. O representante abre o aplicativo.
2. Faz login com suas credenciais.
3. Acessa o menu principal.
4. Consulta ou cadastra clientes.
5. Consulta produtos disponíveis.
6. Cria um pedido normal ou de troca.
7. Informa as quantidades dos produtos.
8. Envia o pedido.
9. Recebe uma mensagem de sucesso.
10. Acompanha o pedido no histórico.

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

Usuário utilizado durante o desenvolvimento:

```text
REPRESENTANTE
E-mail: representante@biscoitoskaue.com
Senha: 123456
```

Observação: os usuários podem variar conforme os dados cadastrados no backend.

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

APK:

[Baixar APK do aplicativo mobile](https://drive.google.com/file/d/1AYGlK3rkz0xZrCHLfP76-dT7p7OwhFVs/view?usp=sharing)

---

## Autor

Desenvolvido por **Kaue Marques Magnus**.

Projeto desenvolvido para a disciplina de Projeto de Desenvolvimento de Software do curso de Análise e Desenvolvimento de Sistemas.

---

## Licença

Projeto acadêmico desenvolvido para fins educacionais.
