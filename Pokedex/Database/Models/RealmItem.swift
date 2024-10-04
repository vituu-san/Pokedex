//
//  RealmItem.swift
//  Pokedex
//
//  Created by Vitor Costa on 03/10/24.
//

import Foundation
import RealmSwift

final class RealmItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var urlString: String = ""
    
    convenience init(name: String, urlString: String) {
        self.init()
        self.name = name
        self.urlString = urlString
    }
}

extension RealmItem: ModelConvertible {
    typealias ModelType = Item
    
    func asModel() -> Item {
        Item(name: name, urlString: urlString)
    }
}
