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
        let result = sut.handle(Pokemon.self, from: data)
        switch result {
        case .success(let pokemon):
            XCTAssertEqual(pokemon.id, 35)
        case .failure:
            XCTFail("Unexpected error!")
        }
    }
    
    func testFailure_ShouldReturnError() {
        let data = JSONHandler().loadJsonData(file: "Pokemon")!
        let result = sut.handle(Ability.self, from: data)
        switch result {
        case .success:
            XCTFail("Unexpected data!")
        case .failure(let error):
            XCTAssertEqual(error, .decodingError(NSError()))
        }
    }
}
