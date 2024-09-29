//
//  Pokemon.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    var id: Int
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
        var value: Pokemon.Ability.Value
        
        enum CodingKeys: String, CodingKey {
            case isHidden
            case value = "ability"
        }
        
        struct Value: Codable {
            var name: String
        }
    }
    
    struct Move: Codable {
        var value: Pokemon.Move.Value
        
        enum CodingKeys: String, CodingKey {
            case value = "move"
        }
        
        struct Value: Codable {
            var name: String
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
        var value: Pokemon.Stat.Value
        
        enum CodingKeys: String, CodingKey {
            case base = "base_stat"
            case value = "stat"
        }
        
        struct Value: Codable {
            var name: String
        }
    }
    
    struct PokemonType: Codable {
        var name: String?
    }
}
