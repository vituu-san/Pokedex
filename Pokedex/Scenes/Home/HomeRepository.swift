//
//  ListRepository.swift
//  Pokedex
//
//  Created by Vitor Costa on 01/10/24.
//

import Foundation
import RealmSwift

enum SearchResult {
    case pokemon(Pokemon)
    case kind(Kind)
    case unknown
}

protocol HomeRepositoring {
    func fetchPage(by id: Int, completion: @escaping (Result<Page, HTTPError>) -> Void)
    func fetchForSearch(by keyword: String, completion: @escaping (Result<SearchResult, HTTPError>) -> Void)
    func fetchObjects<T: Decodable>(by urls: [URL?]) -> [T]
}

final class HomeRepository: HomeRepositoring {
    private var networkService: NetworkServicing
    private var realmService: RealmServicing
    private var multiRequestService: MultiRequestServicing
    private var decodeHandler: DecodeHandling
    
    init(networkService: NetworkServicing = NetworkService(),
         multiRequestService: MultiRequestServicing = MultiRequestService(),
         decodeHandler: DecodeHandling = DecodeHandler(),
         realmService: RealmServicing = RealmService()) {
        self.networkService = networkService
        self.realmService = realmService
        self.multiRequestService = multiRequestService
        self.decodeHandler = decodeHandler
    }
    
    private func endpoint<T: Decodable>(of type: T.Type, keyword: String = "") -> APIEndpoint {
        switch type {
        case is Pokemon.Type: return APIEndpoint.pokemon()
        case is Kind.Type: return APIEndpoint.kind()
        case is Specie.Type: return APIEndpoint.specie()
        case is Move.Type: return APIEndpoint.move()
        default: break
        }
        return .custom(URL(string: ""))
    }
    
    func fetchObjects<T: Decodable>(by urls: [URL?]) -> [T] {
        var objects = [T]()
        multiRequestService.performRequests(urls) { [weak self] results in
            for result in results {
                switch result {
                case .success(let data):
                    if let object = self?.decodeHandler.handle(T.self, from: data) {
                        objects.append(object)
                    }
                case .failure(let error):
                    debugPrint("Failure when fetchAll/startMultiRequest. Description: \(error)")
                }
            }
        }
        return objects
    }
    
    func fetchForSearch(by keyword: String, completion: @escaping (Result<SearchResult, HTTPError>) -> Void) {
        if let realmPokemonList = realmService.fetchAll(of: RealmPokemon.self) {
            if let filteredPokemon = Array(realmPokemonList).filter({ $0.name == keyword }).first {
                completion(.success(.pokemon(filteredPokemon.asModel())))
            }
        }

        let urls = generateURLs(for: keyword)
        multiRequestService.performRequests(urls) { [weak self] results in
            for result in results {
                switch result {
                case .success(let data):
                    if let decodedPokemon = self?.decodeHandler.handle(Pokemon.self, from: data) {
                        completion(.success(.pokemon(decodedPokemon)))
                    } else if let decodedKind = self?.decodeHandler.handle(Kind.self, from: data) {
                        completion(.success(.kind(decodedKind)))
                    } else {
                        completion(.success(.unknown))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchPage(by id: Int, completion: @escaping (Result<Page, HTTPError>) -> Void) {
        if let realmPage = realmService.fetchObject(of: RealmPage.self, byID: id) {
            completion(.success(realmPage.asModel()))
        } else {
            fetchAll(Pokemon.self, of: (offset: id * 20, limit: 20)) { [weak self] result in
                switch result {
                case .success(let pokemons):
                    let page = Page(id: id, pokemons: pokemons)
                    self?.save(page: page)
                    completion(.success(page))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchAll<T: Decodable>(_ type: T.Type,
                                of range: (offset: Int, limit: Int),
                                completion: @escaping (Result<[T], HTTPError>) -> Void) {
        var items = Items(count: 0, results: [])
        var objects = [T]()
        let parameters = ["offset": range.offset, "limit": range.limit]
        
        networkService.fetch(endpoint: endpoint(of: type), parameters: parameters) { [weak self] result in
            switch result {
            case .success(let data):
                if let decodedItems = self?.decodeHandler.handle(Items.self, from: data),
                   items.count < decodedItems.count {
                    items.results.append(contentsOf: decodedItems.results)
                    let urls = items.results.compactMap({ URL(string: $0.urlString) })
                    objects.append(contentsOf: self?.fetchObjects(by: urls) ?? [])
                    completion(.success(objects))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func generateURLs(for keyword: String) -> [URL?] {
        let pokemonURL = APIEndpoint.pokemon(keyword).url
        let kindURL = APIEndpoint.kind(keyword).url
        return [pokemonURL, kindURL]
    }
    
    private func save(page: Page) {
        let realmPokemons = page.pokemons.map({ $0.asRealmObject() })
        let list: List<RealmPokemon> = realmPokemons.toList()
        let page = RealmPage(id: page.id, pokemons: list)
        realmService.save(page)
    }
}
