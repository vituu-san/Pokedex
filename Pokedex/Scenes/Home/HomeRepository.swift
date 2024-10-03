//
//  ListRepository.swift
//  Pokedex
//
//  Created by Vitor Costa on 01/10/24.
//

import Foundation
import RealmSwift

protocol HomeRepositoring {
    func fetch(page id: Int, completion: @escaping (Result<Page, HTTPError>) -> Void)
    func fetch(keyword: String, completion: @escaping (Kind?, Pokemon?) -> Void)
}

final class HomeRepository: HomeRepositoring {
    private var networkService: NetworkServicing
    private var realmService: RealmServicing
    private var multiRequestService: MultiRequestServicing
    private var networkRepository: NetworkRepositoring
    
    init(networkService: NetworkServicing,
         realmService: RealmServicing,
         multiRequestService: MultiRequestServicing,
         networkRepository: NetworkRepositoring) {
        self.networkService = networkService
        self.realmService = realmService
        self.multiRequestService = multiRequestService
        self.networkRepository = networkRepository
    }
    
    func fetch(keyword: String, completion: @escaping (Kind?, Pokemon?) -> Void) {
        networkRepository.searchFor(keyword) { result in
            switch result {
            case .success(let searchResult):
                switch searchResult {
                case .kind(let kind):
                    completion(kind, nil)
                case .pokemon(let pokemon):
                    completion(nil, pokemon)
                case .unknown:
                    completion(nil, nil)
                }
            case .failure(let error):
                debugPrint("Error when fetch keyword. Description: \(error)")
                completion(nil, nil)
            }
        }
    }
    
    func fetch(page id: Int, completion: @escaping (Result<Page, HTTPError>) -> Void) {
        if let realmPage = realmService.fetchObject(of: RealmPage.self, byID: id) {
            completion(.success(realmPage.asModel()))
        } else {
            fetchPokemonsFromNetwork(page: id, completion: completion)
        }
    }
    
    private func fetchPokemonsFromNetwork(page: Int, completion: @escaping (Result<Page, HTTPError>) -> Void) {
        let parameters = ["offset": page * 20, "limit": 20]
        networkService.fetch(type: Items.self, endpoint: .pokemon(), parameters: parameters) { [weak self] result in
            switch result {
            case .success(let pokemons):
                let urls = pokemons.results.compactMap({ URL(string: $0.urlString) })
                self?.fetchAllPokemons(page: page, with: urls, completion: completion)
            case .failure(let error):
                completion(.failure(error))
                debugPrint("Failure when fetching Pokemons. Description: \(error)")
            }
        }
    }
    
    private func fetchAllPokemons(page: Int, with urls: [URL], completion: @escaping (Result<Page, HTTPError>) -> Void) {
        multiRequestService.performRequests(urls) { [weak self] results in
            var pokemons: [Pokemon] = []
            for result in results {
                switch result {
                case .success(let pokemonData):
                    if let pokemon = DecodeHandler().handle(Pokemon.self, from: pokemonData) {
                        pokemons.append(pokemon)
                    } else {
                        completion(.failure(.unknowError))
                    }

                case .failure:
                    completion(.failure(.unknowError))
                }
            }
            let page = Page(id: page, pokemons: pokemons)
            self?.save(page: page)
            completion(.success(page))
        }
    }
    
    private func save(page: Page) {
        let realmPokemons = page.pokemons.map({ $0.asRealmObject() })
        let list: List<RealmPokemon> = realmPokemons.toList()
        let page = RealmPage(id: page.id, pokemons: list)
        
        realmService.save(page)
    }
}
