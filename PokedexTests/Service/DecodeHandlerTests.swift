//
//  DecodeHandlerTests.swift
//  PokedexTests
//
//  Created by Vitor Costa on 29/09/24.
//

import XCTest

@testable import Pokedex

final class DecodeHandlerTests: XCTestCase {
    private var sut: DecodeHandler!
    
    override func setUp() {
        sut = DecodeHandler()
    }

    override func tearDown() {
        sut = nil
    }

    func testSuccess_ShouldReturnObject() {
        let data = JSONHandler().loadJsonData(file: "Pokemon")!
        let pokemon = sut.handle(Pokemon.self, from: data)
        XCTAssertNotNil(pokemon)
        XCTAssertEqual(pokemon?.id, 35)
    }
    
    func testFailure_ShouldBeNil() {
        let data = JSONHandler().loadJsonData(file: "Pokemon")!
        let ability = sut.handle(Ability.self, from: data)
        XCTAssertNil(ability)
    }
}
