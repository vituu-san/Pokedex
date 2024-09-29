//
//  Move.swift
//  Pokedex
//
//  Created by Vitor Costa on 28/09/24.
//

import Foundation

struct Move: Identifiable, Codable {
    var id: Int
    var name: String
    var accuracy: Int
    var power: Int
    var damageClass: DamageClass
    
    enum CodingKeys: String, CodingKey {
        case id, name, accuracy, power
        case damageClass = "move_damage_class"
    }
    
    struct DamageClass: Codable {
        var name: String
    }
}
