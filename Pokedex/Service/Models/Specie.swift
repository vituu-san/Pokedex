//
//  Specie.swift
//  Pokedex
//
//  Created by Vitor Costa on 28/09/24.
//

import Foundation

struct Specie: Identifiable, Codable {
    var id: Int
    var name: String
    var color: SpecieColor
    var isBaby: Bool
    var isLegendary: Bool
    var isMythical: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, color
        case isBaby = "is_baby"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
    }
    
    struct SpecieColor: Codable {
        var name: String
    }
}
