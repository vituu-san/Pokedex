//
//  Convertible.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import RealmSwift

protocol RealmConvertible {
    associatedtype RealmType: Object
    
    func asRealmObject() -> RealmType
}

protocol ModelConvertible: Codable {
    associatedtype ModelType
    
    func asModel() -> ModelType
}
