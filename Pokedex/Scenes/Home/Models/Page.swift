//
//  Page.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation

struct Page: Identifiable, Codable {
    var id: Int
    var pokemons: [Pokemon]
}

extension Page: RealmConvertible {
    typealias RealmType = RealmPage
    
    func asRealmObject() -> RealmPage {
        RealmPage(id: id, pokemons: pokemons.toList())
    }
}
