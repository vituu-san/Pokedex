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
    case pokemon(String? = nil)
    case specie(String? = nil)
    case ability(String? = nil)
    case move(String? = nil)
    case kind(String? = nil)
    case custom(urlString: String)
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
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
        case .pokemon(let name): return "pokemon/\(name ?? "")"
        case .specie(let name): return "pokemon-species/\(name ?? "")"
        case .ability(let name): return "ability/\(name ?? "")"
        case .move(let name): return "move/\(name ?? "")"
        case .kind(let name): return "type/\(name ?? "")"
        default: return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: .get
        }
    }
}
