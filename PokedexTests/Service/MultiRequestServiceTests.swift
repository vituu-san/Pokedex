//
//  MultiRequestServiceTests.swift
//  PokedexTests
//
//  Created by Vitor Costa on 30/09/24.
//

import XCTest

@testable import Pokedex

final class MultiRequestServiceTests: XCTestCase {
    private var sut: MultiRequestService!
    private var sessionMock: URLSessionMock!

    override func setUp() {
        sessionMock = URLSessionMock()
        sut = MultiRequestService(session: sessionMock)
    }

    override func tearDown() {
        sessionMock = nil
        sut = nil
    }

    func testPerformRequests_WithSuccess_ShouldReturnAllObjects() {
        let expectedData = JSONHandler().loadJsonData(file: "Pokemons")
        sessionMock.data = expectedData
        let pokemons = try! JSONDecoder().decode(Pokemons.self, from: expectedData!)
        let urls = pokemons.results.map({ URL(string: $0.urlString)! })
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectation = expectation(description: "Fetch test.")
        sut.performRequests(urls) { results in
            XCTAssertEqual(results.count, 5)
            
            for result in results {
                switch result {
                case .success(let data):
                    XCTAssertEqual(data, expectedData)
                case .failure:
                    XCTFail("Unexpected error.")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
    
    func testPerformRequests_WithFailureWithoutData_ShouldReturnUnknowError() {
        let urls = [
            URL(string: "www.nscren.com.br"),
            URL(string: "www.imusic.com.br")
        ]
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectation = expectation(description: "Fetch test.")
        sut.performRequests(urls) { results in
            XCTAssertEqual(results.count, 2)
            
            for result in results {
                switch result {
                case .success:
                    XCTFail("Unexpected data.")
                case .failure(let error):
                    XCTAssertEqual(error, .unknowError)
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
}
