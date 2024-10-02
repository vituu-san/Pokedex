//
//  Array+Extensions.swift
//  Pokedex
//
//  Created by Vitor Costa on 01/10/24.
//

import Foundation
import RealmSwift

extension Array {
    func toList<T: Object>() -> List<T> {
        guard let array = self as? [T] else {
            return List<T>()
        }

        let list = List<T>()
        list.append(objectsIn: array)
        return list
    }
}
