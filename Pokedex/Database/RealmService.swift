//
//  RealmService.swift
//  Pokedex
//
//  Created by Vitor Costa on 01/10/24.
//

import Foundation
import RealmSwift

protocol RealmServicing {
    func save<T: Object>(_ object: T)
    func saveList<T: Object>(_ objects: List<T>)
    func fetchObject<T: Object>(of type: T.Type, byID id: Int) -> T?
    func fetchAll<T: Object>(of type: T.Type) -> Results<T>?
}

class RealmService: RealmServicing {
    private var realm: Realm
    
    init(config: Realm.Configuration = .defaultConfiguration) {
        do {
            self.realm = try Realm(configuration: config)
        } catch let error {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func save<T: Object>(_ object: T) {
        do {
            try realm.write { realm.add(object, update: .modified) }
        } catch let error {
            debugPrint("Database failure when save. Description: \(error)")
        }
    }
    
    func saveList<T: Object>(_ objects: List<T>) {
        do {
            try realm.write {
                for object in objects {
                    realm.add(object, update: .modified)
                }
            }
        } catch let error {
            debugPrint("Database failure when saveObjects. Description: \(error)")
        }
    }
    
    func fetchObject<T: Object>(of type: T.Type, byID id: Int) -> T? {
        return realm.object(ofType: type.self, forPrimaryKey: id)
    }

    func fetchAll<T: Object>(of type: T.Type) -> Results<T>? {
        return realm.objects(type.self)
    }
}
