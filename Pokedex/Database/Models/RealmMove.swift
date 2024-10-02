//
//  RealmMove.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import RealmSwift

final class RealmMove: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var accuracy: Int = 0
    @objc dynamic var power: Int = 0
    @objc dynamic var damageClass: String
    
    convenience init(id: Int, name: String, accuracy: Int, power: Int, damageClass: String) {
        self.init()
        self.id = id
        self.name = name
        self.accuracy = accuracy
        self.power = power
        self.damageClass = damageClass
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

extension RealmMove: ModelConvertible {
    typealias ModelType = Move
    
    func asModel() -> Move {
        Move(id: id , name: name, accuracy: accuracy, power: power, damageClass: Move.DamageClass(name: damageClass))
    }
}
