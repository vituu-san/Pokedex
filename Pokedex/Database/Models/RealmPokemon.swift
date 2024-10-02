//
//  RealmPokemon.swift
//  Pokedex
//
//  Created by Vitor Costa on 01/10/24.
//

import Foundation
import RealmSwift

final class RealmPokemon: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var height: Int = 0
    @objc dynamic var weight: Int = 0
    @objc dynamic var species: RealmPokemonSpecie?
    var abilities = List<RealmPokemonAbility>()
    var moves = List<RealmPokemonMove>()
    @objc dynamic var sprites: RealmSprites?
    var stats = List<RealmStat>()
    var types = List<RealmPokemonType>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, 
         name: String,
         height: Int,
         weight: Int,
         species: RealmPokemonSpecie?, 
         abilities: List<RealmPokemonAbility>,
         moves: List<RealmPokemonMove>,
         sprites: RealmSprites?,
         stats: List<RealmStat>,
         types: List<RealmPokemonType>) {
        self.init()
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.species = species
        self.abilities = abilities
        self.moves = moves
        self.sprites = sprites
        self.stats = stats
        self.types = types
    }
}

extension RealmPokemon: ModelConvertible {
    typealias ModelType = Pokemon
    
    func asModel() -> Pokemon {
        return Pokemon(
            id: id,
            name: name,
            height: height,
            weight: weight,
            species: species?.asModel() ?? Pokemon.Specie(name: ""),
            abilities: abilities.map { $0.asModel() },
            moves: moves.map { $0.asModel() },
            sprites: sprites?.asModel() ?? Pokemon.Sprites(front: "", frontShiny: ""),
            stats: stats.map { $0.asModel() },
            types: types.map { $0.asModel() }
        )
    }
}

final class RealmPokemonSpecie: Object {
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override class func primaryKey() -> String? {
        return "name"
    }
}

extension RealmPokemonSpecie: ModelConvertible {
    typealias ModelType = Pokemon.Specie
    
    func asModel() -> Pokemon.Specie {
        return Pokemon.Specie(name: name)
    }
}

final class RealmPokemonAbility: Object {
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var name: String = ""
    @objc dynamic var urlString: String = ""
    
    convenience init(isHidden: Bool, name: String, urlString: String) {
        self.init()
        self.isHidden = isHidden
        self.name = name
        self.urlString = urlString
    }
}

extension RealmPokemonAbility: ModelConvertible {
    typealias ModelType = Pokemon.Ability
    
    func asModel() -> Pokemon.Ability {
        return Pokemon.Ability(
            isHidden: isHidden,
            value: Item(name: name, urlString: urlString)
        )
    }
}

final class RealmPokemonMove: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var urlString: String = ""
    
    convenience init(name: String, urlString: String) {
        self.init()
        self.name = name
        self.urlString = urlString
    }
}

extension RealmPokemonMove: ModelConvertible {
    typealias ModelType = Pokemon.Move
    
    func asModel() -> Pokemon.Move {
        return Pokemon.Move(
            value: Item(name: name, urlString: urlString)
        )
    }
}

final class RealmSprites: Object {
    @objc dynamic var front: String = ""
    @objc dynamic var frontShiny: String = ""
    
    convenience init(front: String, frontShiny: String) {
        self.init()
        self.front = front
        self.frontShiny = frontShiny
    }
}

extension RealmSprites: ModelConvertible {
    typealias ModelType = Pokemon.Sprites
    
    func asModel() -> Pokemon.Sprites {
        return Pokemon.Sprites(front: front, frontShiny: frontShiny)
    }
}

final class RealmStat: Object {
    @objc dynamic var base: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var urlString: String = ""
    
    convenience init(base: Int, name: String, urlString: String) {
        self.init()
        self.base = base
        self.name = name
        self.urlString = urlString
    }
}

extension RealmStat: ModelConvertible {
    typealias ModelType = Pokemon.Stat
    
    func asModel() -> Pokemon.Stat {
        return Pokemon.Stat(
            base: base,
            value: Item(name: name, urlString: urlString)
        )
    }
}

final class RealmPokemonType: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var urlString: String = ""
    
    convenience init(name: String, urlString: String) {
        self.init()
        self.name = name
        self.urlString = urlString
    }
}

extension RealmPokemonType: ModelConvertible {
    typealias ModelType = Pokemon.PokemonType
    
    func asModel() -> Pokemon.PokemonType {
        return Pokemon.PokemonType(
            type: Item(name: name, urlString: urlString)
        )
    }
}
