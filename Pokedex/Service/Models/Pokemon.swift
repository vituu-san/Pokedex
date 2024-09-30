//
//  Pokemon.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    var id: Int
    var name: String
    var height: Int
    var weight: Int
    var species: Specie
    var abilities: [Ability]
    var moves: [Move]
    var sprites: Sprites
    var stats: [Stat]
    var types: [PokemonType]
    
    struct Specie: Codable {
        var name: String
    }
    
    struct Ability: Codable {
        var isHidden: Bool?
        var value: Item
        
        enum CodingKeys: String, CodingKey {
            case isHidden
            case value = "ability"
        }
    }
    
    struct Move: Codable {
        var value: Item
        
        enum CodingKeys: String, CodingKey {
            case value = "move"
        }
    }

    struct Sprites: Codable {
        var front: String
        var frontShiny: String
        
        enum CodingKeys: String, CodingKey {
            case front = "front_default"
            case frontShiny = "front_shiny"
        }
    }

    struct Stat: Codable {
        var base: Int
        var value: Item
        
        enum CodingKeys: String, CodingKey {
            case base = "base_stat"
            case value = "stat"
        }
    }
    
    struct PokemonType: Codable {
        var type: Item
    }
}

// MARK: - RealmConvertible
import RealmSwift

extension Pokemon {
    typealias RealmType = RealmPokemon
    
    func asRealmObject() -> RealmPokemon {
        RealmPokemon(id: id,
                     name: name,
                     height: height,
                     weight: weight,
                     species: species.asRealmObject(),
                     abilities: abilities.map({ $0.asRealmObject() }).toList(),
                     moves: moves.map({ $0.asRealmObject() }).toList(),
                     sprites: sprites.asRealmObject(),
                     stats: stats.map({ $0.asRealmObject() }).toList(),
                     types: types.map({ $0.asRealmObject() }).toList())
    }
}

extension Pokemon.Specie: RealmConvertible {
    typealias RealmType = RealmPokemonSpecie
    
    func asRealmObject() -> RealmPokemonSpecie {
        RealmPokemonSpecie(name: name)
    }
}

extension Pokemon.Ability: RealmConvertible {
    typealias RealmType = RealmPokemonAbility
    
    func asRealmObject() -> RealmPokemonAbility {
        RealmPokemonAbility(isHidden: isHidden ?? false, name: value.name, urlString: value.urlString)
    }
}

extension Pokemon.Move: RealmConvertible {
    typealias RealmType = RealmPokemonMove
    
    func asRealmObject() -> RealmPokemonMove {
        RealmPokemonMove(name: value.name, urlString: value.urlString)
    }
}

extension Pokemon.Sprites: RealmConvertible {
    typealias RealmType = RealmSprites
    
    func asRealmObject() -> RealmSprites {
        RealmSprites(front: front, frontShiny: frontShiny)
    }
}

extension Pokemon.Stat: RealmConvertible {
    typealias RealmType = RealmStat
    
    func asRealmObject() -> RealmStat {
        RealmStat(base: base, name: value.name, urlString: value.urlString)
    }
}

extension Pokemon.PokemonType: RealmConvertible {
    typealias RealmType = RealmPokemonType
    
    func asRealmObject() -> RealmPokemonType {
        RealmPokemonType(name: type.name, urlString: type.urlString)
    }
}
