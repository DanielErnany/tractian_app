# Tractian App

## Visão Geral

Este projeto é um aplicativo móvel desenvolvido em Flutter para gerenciamento de ativos e locais. Ele permite a visualização hierárquica de locais, ativos e componentes, com funcionalidades de busca e filtros avançados. O projeto foi desenvolvido como um teste prático.

## Demonstração

Para uma demonstração completa do aplicativo, assista ao vídeo a seguir:

[![Assista ao Vídeo](https://img.youtube.com/vi/KyrSqBhYLS0/maxresdefault.jpg)](https://www.youtube.com/watch?v=KyrSqBhYLS0)

## Funcionalidades

- **Visualização Hierárquica**: Exibe locais, ativos e componentes em uma estrutura de árvore.
- **Filtros Avançados**: Filtra por tipo de sensor e status dos componentes.
- **Busca de Ativos e Locais**: Permite a busca rápida de ativos e locais específicos.
- **Carregamento Dinâmico de Dados**: Carrega dados de uma API utilizando o padrão Provider para gerenciamento de estado.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento do aplicativo móvel.
- **Provider**: Gerenciamento de estado.
- **API REST**: Comunicação com o servidor para carregar dados.
- **HTTP**: Pacote utilizado para realizar requisições HTTP.

## Estrutura do Projeto

```plaintext
lib/
├── models/
│   ├── asset.dart
│   ├── companie.dart
│   ├── component.dart
│   ├── item.dart
│   ├── location.dart
├── pages/
│   ├── assets_page.dart
│   ├── menu_page.dart
├── providers/
│   ├── assets_provider.dart
├── requests/
│   ├── requests.dart
├── utils/
│   ├── images.dart
│   ├── routes.dart
├── widgets/
│   ├── companie_button.dart
│   ├── filter_button.dart
│   ├── tree_view.dart
```


## Como Executar o Projeto

1. **Clone o repositório:**
    ```bash
    git clone https://github.com/DanielErnany/tractian_app
    ```

2. **Navegue até o diretório do projeto:**
    ```bash
    cd tractian_app
    ```

3. **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4. **Execute o projeto:**
    ```bash
    flutter run
    ```


## Contato

Para dúvidas ou sugestões, entre em contato pelo e-mail: danielernanylf@gmail.com
