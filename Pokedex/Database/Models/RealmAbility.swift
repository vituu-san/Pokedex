//
//  RealmAbility.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import RealmSwift

final class RealmAbility: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    var effects = List<RealmAbilityEffect>()
    
    convenience init(id: Int, name: String, effects: List<RealmAbilityEffect>) {
        self.init()
        self.id = id
        self.name = name
        self.effects = effects
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

extension RealmAbility: ModelConvertible {
    typealias ModelType = Ability
    
    func asModel() -> Ability {
        Ability(id: id, name: name, effects: effects.map({ $0.asModel() }))
    }
}

final class RealmAbilityEffect: Object {
    @objc dynamic var consequence: String = ""
    @objc dynamic var short: String = ""
    
    convenience init(consequence: String, short: String) {
        self.init()
        self.consequence = consequence
        self.short = short
    }
}

extension RealmAbilityEffect: ModelConvertible {
    typealias ModelType = Ability.Effect
    
    func asModel() -> Ability.Effect {
        Ability.Effect(consequence: consequence, short: short)
    }
}

