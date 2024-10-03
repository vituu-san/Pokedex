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
    func fetchPokemonsList(at page: Int)
    func search(keyword: String)
}

final class HomeController: HomeControlling {
    private var repository: HomeRepositoring
    
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading: Bool = false
    
    init(repository: HomeRepositoring) {
        self.repository = repository
    }
    
    func fetchPokemonsList(at page: Int) {
        isLoading = true
        repository.fetch(page: page) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let page):
                self?.pokemons.append(contentsOf: page.pokemons)
            case .failure(let error):
                // TODO: Criar método de gerencia de estados para a view.
                debugPrint("Failure when fetching Pokemons. Description: \(error)")
            }
        }
    }
    
    func search(keyword: String) {
        repository.fetch(keyword: keyword) { [weak self] kind, pokemon in
            if let kind {
                // TODO: Buscar toda a lista de Pokemons no Kind, baixar os dados de cada um e popular a lista `pokemons`.
            } else if let pokemon {
                self?.pokemons.append(pokemon)
            }
        }
    }
}
