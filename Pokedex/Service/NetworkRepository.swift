//
//  NetworkRepository.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation

protocol NetworkRepositoring {
    func fetchAllItems(endpoint: APIEndpoint,
                       limit: Int,
                       completion: @escaping (Result<Items, HTTPError>) -> Void)
    func searchFor(_ keyword: String, completion: @escaping (Result<SearchResult, HTTPError>) -> Void)
}

enum SearchResult {
    case pokemon(Pokemon)
    case kind(Kind)
    case unknown
}

final class NetworkRepository: NetworkRepositoring {
    private var networkService: NetworkServicing
    private var multiRequestService: MultiRequestServicing
    
    init(networkServicing: NetworkServicing,
         multiRequestServicing: MultiRequestServicing) {
        self.networkService = networkServicing
        self.multiRequestService = multiRequestServicing
    }
    
    func fetchAllItems(endpoint: APIEndpoint,
                       limit: Int,
                       completion: @escaping (Result<Items, HTTPError>) -> Void) {
        var offset: Int = .zero
        var items = Items(count: .zero, results: [])
        let parameters = ["offset": offset, "limit": limit]
        
        func fetchNextBatch() {
            networkService.fetch(type: Items.self, endpoint: endpoint, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    items.results.append(contentsOf: response.results)
                    if items.results.count < response.results.count {
                        offset += limit
                        fetchNextBatch()
                    } else {
                        completion(.success(items))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        fetchNextBatch()
    }
    
    func searchFor(_ keyword: String, completion: @escaping (Result<SearchResult, HTTPError>) -> Void) {
        let urls = generateURLs(for: keyword)
        
        multiRequestService.performRequests(urls) { results in
            for result in results {
                switch result {
                case .success(let data):
                    let decodeHandler = DecodeHandler()
                    if let decodedPokemon = decodeHandler.handle(Pokemon.self, from: data) {
                        completion(.success(.pokemon(decodedPokemon)))
                        return
                    } else if let decodedKind = decodeHandler.handle(Kind.self, from: data) {
                        completion(.success(.kind(decodedKind)))
                        return
                    } else {
                        completion(.success(.unknown))
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func generateURLs(for keyword: String) -> [URL?] {
        let pokemonURL = URL(string: APIEndpoint.pokemon(keyword).baseURLString)
        let kindURL = URL(string: APIEndpoint.kind(keyword).baseURLString)
        return [pokemonURL, kindURL]
    }
}
