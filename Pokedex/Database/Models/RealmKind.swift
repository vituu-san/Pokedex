//
//  RealmKind.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import RealmSwift

final class RealmKind: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    var pokemons = List<RealmItem>()
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(id: Int, name: String, pokemons: List<RealmItem>) {
        self.init()
        self.id = id
        self.name = name
        self.pokemons = pokemons
    }
}

extension RealmKind: ModelConvertible {
    typealias ModelType = Kind
    
    func asModel() -> Kind {
        Kind(id: id, name: name, pokemons: pokemons.map { Kind.Related(pokemon: $0.asModel()) })
    }
}
