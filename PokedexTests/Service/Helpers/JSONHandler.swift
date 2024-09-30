//
//  JSONHandler.swift
//  PokedexTests
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

final class JSONHandler {
    func loadJsonData(file: String) -> Data? {
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
}
