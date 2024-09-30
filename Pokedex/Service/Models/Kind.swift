//
//  Kind.swift
//  Pokedex
//
//  Created by Vitor Costa on 30/09/24.
//

import Foundation

struct Kind: Identifiable, Codable {
    var id: Int
    var name: String
    var pokemons: [Related]
    
    struct Related: Codable {
        var pokemon: Item
    }
}

extension Kind: RealmConvertible {
    typealias RealmType = RealmKind
    
    func asRealmObject() -> RealmKind {
        RealmKind(id: id, name: name, pokemons: pokemons.toList())
    }
}
