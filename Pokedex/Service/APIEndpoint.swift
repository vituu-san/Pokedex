//
//  APIEndpoint.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

/// Retorna uma URL de acordo com os endpoints mapeados.
enum APIEndpoint {
    case pokemons
    case pokemon(name: String)
    case specie(name: String)
    case ability(name: String)
    case move(name: String)
    case custom(urlString: String)
    
    var url: URL? {
        switch self {
        case let .custom(urlString): return URL(string: urlString)
        default: return URL(string: baseURLString + path)
        }
    }
    
    var baseURLString: String { "https://pokeapi.co/api/v2/" }
    
    var path: String {
        switch self {
        case .pokemons: return "pokemon/"
        case .pokemon(let name): return "pokemon/\(name)"
        case .specie(let name): return "specie/\(name)"
        case .ability(let name): return "ability/\(name)"
        case .move(let name): return "move/\(name)"
        default: return ""
        }
    }
}
