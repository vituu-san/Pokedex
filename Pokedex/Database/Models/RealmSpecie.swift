//
//  RealmSpecie.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import RealmSwift

final class RealmSpecie: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var colorName: String = ""
    @objc dynamic var isBaby: Bool = false
    @objc dynamic var isLegendary: Bool = false
    @objc dynamic var isMythical: Bool = false
    
    convenience init(id: Int,
                     name: String,
                     colorName: String,
                     isBaby: Bool,
                     isLegendary: Bool,
                     isMythical: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.colorName = colorName
        self.isBaby = isBaby
        self.isLegendary = isLegendary
        self.isMythical = isMythical
    }
}

extension RealmSpecie: ModelConvertible {
    typealias ModelType = Specie
    
    func asModel() -> Specie {
        Specie(id: id,
               name: name,
               color: Specie.SpecieColor(name: colorName),
               isBaby: isBaby,
               isLegendary: isLegendary,
               isMythical: isMythical)
    }
}
