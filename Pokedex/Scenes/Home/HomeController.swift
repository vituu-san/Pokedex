//
//  HomeController.swift
//  Pokedex
//
//  Created by Vitor Costa on 30/09/24.
//

import Foundation

protocol HomeControlling: ObservableObject {
    var isLoading: Bool { get }
    var pokemons: [Pokemon] { get }
    func fetchPokemonsList(by pageID: Int)
    func search(keyword: String)
}

final class HomeController: HomeControlling {
    private var repository: HomeRepositoring
    
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading: Bool = false
    
    init(repository: HomeRepositoring) {
        self.repository = repository
    }
    
    func fetchPokemonsList(by pageID: Int) {
        isLoading = true
        repository.fetchPage(by: pageID) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let page):
                self?.pokemons.append(contentsOf: page.pokemons)
            case .failure(let error):
                // TODO: Criar gerenciamento de estado: Error.
                debugPrint("Failure when fetching Pokemons. Description: \(error)")
            }
        }
    }
    
    func search(keyword: String) {
        repository.fetchForSearch(by: keyword) { [weak self] result in
            switch result {
            case .success(let object):
                switch object {
                case .pokemon(let pokemon):
                    self?.pokemons.append(pokemon)
                case .kind(let kind):
                    let urls = kind.pokemons.map({ URL(string: $0.pokemon.urlString) })
                    if let pokemons: [Pokemon] = self?.repository.fetchObjects(by: urls) {
                        self?.pokemons.append(contentsOf: pokemons)
                    } else {
                        // TODO: Criar gerenciamento de estado: Empty.
                    }
                default:
                    // TODO: Criar gerenciamento de estado: Error.
                    debugPrint("Failure on fetchForSearch at \(HomeController.self). Description: unkow error")
                }
                
            case .failure(let error):
                // TODO: Estado de erro.
                debugPrint("Failure on fetchForSearch at \(HomeController.self). Description: \(error)")
            }
        }
    }
}
