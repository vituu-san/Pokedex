//
//  NetworkServiceTests.swift
//  PokedexTests
//
//  Created by Vitor Costa on 29/09/24.
//

import XCTest

@testable import Pokedex

final class NetworkServiceTests: XCTestCase {
    private var sut: NetworkService!
    private var sessionMock: URLSessionMock!

    override func setUp() {
        sessionMock = URLSessionMock()
        sut = NetworkService(urlSession: sessionMock)
    }

    override func tearDown() {
        sessionMock = nil
        sut = nil
    }

    func testFetch_onSuccess_ShouldReturnObject() {
        let data = JSONHandler().loadJsonData(file: "Pokemon")
        sessionMock.data = data
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectation = expectation(description: "Fetch test.")
        sut.fetch(type: Pokemon.self, endpoint: .pokemon("")) { result in
            switch result {
            case .success(let pokemon):
                XCTAssertEqual(pokemon.id, 35)
                XCTAssertEqual(pokemon.name, "clefairy")
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected error.")
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
    
    func testFetch_onFailureNoData_ShouldReturnUnknowError() {
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectation = expectation(description: "Fetch test.")
        sut.fetch(type: Pokemon.self, endpoint: .pokemon("")) { result in
            switch result {
            case .success:
                XCTFail("Unexpected data.")
            case .failure(let error):
                XCTAssertEqual(error, .unknowError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
    
    func testFetch_onFailureInvalidURL_ShouldReturnInvalidURL() {
        let expectation = expectation(description: "Fetch test.")
        sut.fetch(type: Pokemon.self, endpoint: .custom(urlString: "")) { result in
            switch result {
            case .success:
                XCTFail("Unexpected data.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
}
