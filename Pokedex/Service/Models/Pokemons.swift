//
//  Pokemons.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

struct Pokemons: Codable {
    var next: String?
    var previous: String?
    var results: [Pokemons.Result]
    
    struct Result: Codable {
        var name: String
        var urlString: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case urlString = "url"
        }
    }
}
