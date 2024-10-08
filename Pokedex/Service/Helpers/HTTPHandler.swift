//
//  HTTPHandler.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

/// Retorna um `errorDescription` baseado no erro de uma requisição HTTP dos endpoints mapeados.
enum HTTPError: LocalizedError {
    case invalidResponse
    case badRequest(Int)
    case decodingError(Error)
    case urlError(URLError)
    case invalidURL
    case invalidImageData
    case unknowError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid server response"
        case .badRequest(let code):
            if (400...499).contains(code) { return "Can't connect with server. Code: \(code)" }
            if (500...599).contains(code) { return "Server error. Code: \(code)" }
            return "Has occurred an unknow error."
        case .decodingError(let error): return "Can't decode error. Description: \(error.localizedDescription)"
        case .urlError(let error): return "Can't handle URL. Description: \(error.localizedDescription)"
        case .invalidURL: return "Invalid URL."
        case .invalidImageData: return "The data isn't an image or can be broken."
        case .unknowError: return "Has occurred an unknow error."
        }
    }
}

/// Responsável por lidar com o resultado de uma requisição HTTP.
final class HTTPHandler {
    func handle(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, HTTPError> {
        if let error = error as? URLError {
            return .failure(.urlError(error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(.badRequest(httpResponse.statusCode))
        }
        
        guard let data else {
            return .failure(.unknowError)
        }
        
        return .success(data)
    }
}
