//
//  Ability.swift
//  Pokedex
//
//  Created by Vitor Costa on 28/09/24.
//

import Foundation

struct Ability: Identifiable, Codable {
    var id: Int
    var name: String
    var effects: [Effect]
    
    struct Effect: Codable {
        var consequence: String
        var short: String
        
        enum CodingKeys: String, CodingKey {
            case consequence = "effect"
            case short = "short_effect"
        }
    }
}

extension Ability: RealmConvertible {
    typealias RealmType = RealmAbility
    
    func asRealmObject() -> RealmAbility {
        RealmAbility(id: id, name: name, effects: effects.toList())
    }
}
