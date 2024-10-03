//
//  Item.swift
//  Pokedex
//
//  Created by Vitor Costa on 30/09/24.
//

import Foundation

struct Items: Hashable, Codable {
    var count: Int
    var results: [Item]
}

struct Item: Hashable, Codable {
    var name: String
    var urlString: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case urlString = "url"
    }
}

extension Item: RealmConvertible {
    typealias RealmType = RealmItem
    
    func asRealmObject() -> RealmItem {
        RealmItem(name: name, urlString: urlString)
    }
}

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
