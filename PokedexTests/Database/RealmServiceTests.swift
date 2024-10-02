//
//  RealmServiceTests.swift
//  PokedexTests
//
//  Created by Vitor Costa on 02/10/24.
//

import XCTest
import RealmSwift

@testable import Pokedex

class RealmServiceTests: XCTestCase {
    private var realmService: RealmService!

    override func setUp() {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "RealmServiceTests"
        realmService = RealmService(config: config)
    }

    override func tearDown() {
        realmService = nil
    }

    func testSaveObject() {
        let kind = RealmKind(id: 1, name: "normal", pokemons: List<RealmItem>())
        
        realmService.save(kind)
        
        let fetchedObject = realmService.fetchObject(of: RealmKind.self, byID: 1)
        
        XCTAssertNotNil(fetchedObject)
        XCTAssertEqual(fetchedObject?.name, "normal")
    }

    func testSaveList() {
        let kind1 = RealmKind(id: 1, name: "normal", pokemons: List<RealmItem>())
        let kind2 = RealmKind(id: 2, name: "flying", pokemons: List<RealmItem>())

        let list = List<RealmKind>()
        list.append(kind1)
        list.append(kind2)
        
        realmService.saveList(list)
        
        let allObjects = realmService.fetchAll(of: RealmKind.self)
        
        XCTAssertEqual(allObjects?.count, 2)
        XCTAssertEqual(allObjects?.first?.name, "normal")
        XCTAssertEqual(allObjects?.last?.name, "flying")
    }

    func testFetchObjectByID() {
        let kind1 = RealmKind(id: 5, name: "normal", pokemons: List<RealmItem>())
        
        realmService.save(kind1)
        
        let fetchedObject = realmService.fetchObject(of: RealmKind.self, byID: 5)
        
        XCTAssertNotNil(fetchedObject)
        XCTAssertEqual(fetchedObject?.id, 5)
        XCTAssertEqual(fetchedObject?.name, "normal")
    }

    func testFetchAllObjects() {
        let kind1 = RealmKind(id: 1, name: "normal", pokemons: List<RealmItem>())
        let kind2 = RealmKind(id: 2, name: "flying", pokemons: List<RealmItem>())
        
        realmService.save(kind1)
        realmService.save(kind2)
        
        let allObjects = realmService.fetchAll(of: RealmKind.self)
        
        XCTAssertEqual(allObjects?.count, 2)
    }
}
