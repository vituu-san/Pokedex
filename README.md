# Pokémon Grid App

Este projeto é um aplicativo desenvolvido em SwiftUI que exibe uma lista de Pokémons em uma grade, utilizando a API pública da Pokedex. O aplicativo implementa armazenamento local com Realm para cache de dados e otimização do desempenho, permitindo ao usuário visualizar Pokémons tanto online quanto offline. Além disso, oferece funcionalidades como pesquisa e navegação para detalhes de cada Pokémon.

## Funcionalidades

- Exibe Pokémons em uma grade de duas colunas com imagens.
- Barra de pesquisa para filtrar Pokémons pelo nome.
- Exibe detalhes de cada Pokémon em uma tela dedicada ao tocar em um card.
- Cache de dados usando Realm para otimizar a experiência offline.
- Sincronização assíncrona com a API da Pokedex para garantir que os dados estejam atualizados.

## Tecnologias Utilizadas

- SwiftUI: Framework usado para criar a interface do usuário de forma declarativa.
- Realm: Banco de dados usado para cache e persistência local.
- API PokeAPI: A API gratuita usada para fornecer dados dos Pokémons.

## Estrutura do Projeto

O projeto é desenvolvido seguindo os princípios do SOLID, Clean Code e Clean Architecture, mantendo as responsabilidades separadas entre camadas.

- View: Representa a interface visual do usuário e é construída utilizando componentes do SwiftUI.
- Controller/ViewModel: Responsável pela lógica de negócios e manipulação de dados da View.
- Repository: Manipula as operações de banco de dados Realm e chamadas de API.
- Service: Responsável por fazer requisições HTTP para a API e retornar os dados.

Instalação

1.	Clone o repositório:
2.	Instale as dependências do projeto com Swift Package Manager:
- RealmSwift será automaticamente adicionado como dependência no Package.swift.
3.	Abra o projeto no Xcode (versão 12.0 ou superior).

### Como Usar

1.	Iniciar o App: Execute o app no simulador ou em um dispositivo físico.
2.	Navegar na Grade: Deslize a tela para explorar os diferentes Pokémons apresentados na grade.
3.	Pesquisar Pokémons: Use a barra de pesquisa para filtrar os Pokémons pelo nome.
4.	Detalhes: Toque em qualquer Pokémon para ver uma tela com mais detalhes sobre ele, como o número na Pokedex e habilidades.

### Armazenamento de Dados com Realm

Os Pokémons são buscados inicialmente da PokeAPI e, em seguida, armazenados localmente no Realm. Isso permite que o aplicativo ofereça uma experiência de navegação mais rápida e que os dados sejam acessíveis offline.

Cada vez que o aplicativo é iniciado ou uma busca é feita, ele:

- Primeiro verifica se existem dados armazenados localmente no Realm.
- Caso contrário, realiza uma busca na API para preencher o cache local com os novos dados.

Estrutura do Código

- PokemonListView.swift: Contém a grade de Pokémons com a barra de pesquisa e navegação para a tela de detalhes.
- PokemonDetailView.swift: Exibe as informações detalhadas de um Pokémon selecionado.
- PokemonController.swift: Faz a ponte entre a View e a camada de serviço/repositório, gerenciando o estado e as interações do usuário.
- PokemonRepository.swift: Faz as requisições à API da Pokedex e gerencia o cache usando Realm.

## PokeAPI

A PokeAPI é uma API pública gratuita que fornece informações sobre Pokémons. O aplicativo faz uso das seguintes funcionalidades da API:

- Listagem de Pokémons.
- Informações detalhadas de cada Pokémon, incluindo imagens e habilidades.

Requisitos

- Xcode 12 ou superior.
- iOS 14 ou superior.
- Conexão com a internet para buscar dados da PokeAPI (apenas na primeira execução ou quando offline).

Melhorias Futuras

- Implementação de paginação para carregar grandes quantidades de dados de forma otimizada.
- Suporte a favoritos, permitindo que o usuário marque seus Pokémons preferidos.
- Melhorias na navegação entre diferentes categorias de Pokémons.

### Contribuindo

1.	Faça um fork do repositório.
2.	Crie uma branch para a sua feature ou correção (git checkout -b minha-feature).
3.	Faça commit das suas mudanças (git commit -m 'Minha nova feature').
4.	Envie para a branch principal (git push origin minha-feature).
5.	Abra um pull request.

### Licença

Este projeto é distribuído sob a Licença MIT. Para mais detalhes, veja o arquivo LICENSE.

### Agradecimentos

- PokeAPI por fornecer dados abertos sobre Pokémons.
- A Realm por disponibilizar um banco de dados simples e eficiente para iOS.