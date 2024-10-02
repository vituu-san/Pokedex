//
//  RealmPage.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import RealmSwift

final class RealmPage: Object {
    @objc dynamic var id: Int = 0
    var pokemons = List<RealmPokemon>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, pokemons: List<RealmPokemon>) {
        self.init()
        self.id = id
        self.pokemons = pokemons
    }
}

extension RealmPage: ModelConvertible {
    typealias ModelType = Page
    
    func asModel() -> Page {
        Page(id: id, pokemons: pokemons.map({ $0.asModel() }))
    }
}
