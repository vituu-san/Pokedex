//
//  DecodeHandler.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

protocol DecodeHandling {
    func handle<T: Decodable>(_ type: T.Type, from data: Data) -> T?
}

/// Responsável por lidar com a decodificação de um `Data` baseado no tipo informado.
final class DecodeHandler: DecodeHandling {
    func handle<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(type.self, from: data)
            return decodedData
        } catch let error {
            debugPrint("Failure when handle. Description: \(error)")
            return nil
        }
    }
}
