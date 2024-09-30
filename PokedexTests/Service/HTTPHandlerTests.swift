//
//  HTTPHandlerTests.swift
//  PokedexTests
//
//  Created by Vitor Costa on 29/09/24.
//

import XCTest

@testable import Pokedex

final class HTTPHandlerTests: XCTestCase {
    private var sut: HTTPHandler!
    
    override func setUp() {
        sut = HTTPHandler()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testHandle_WithData_ShouldReturnSuccess() {
        let response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectedData = JSONHandler().loadJsonData(file: "Pokemon")
        let result = sut.handle(data: expectedData, response: response, error: nil)
        switch result {
        case .success(let data):
            XCTAssertEqual(data, expectedData)
        case .failure:
            XCTFail("Unexpected error!")
        }
    }

    func testHandle_WithoutData_ShouldReturnUnknowError() {
        let response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let result = sut.handle(data: nil, response: response, error: nil)
        switch result {
        case .success:
            XCTFail("Unexpected data!")
        case .failure(let error):
            XCTAssertEqual(error, .unknowError)
        }
    }
    
    func testHandle_WithResponse400_ShouldReturnConnectionUnable() {
        let response = HTTPURLResponse().makeURLResponseMock(with: 400)
        let result = sut.handle(data: nil, response: response, error: nil)
        switch result {
        case .success:
            XCTFail("Unexpected data!")
        case .failure(let error):
            XCTAssertEqual(error, .badRequest(400))
            XCTAssertEqual(error.localizedDescription, "Can't connect with server. Code: 400")
        }
    }
    
    func testHandle_WithResponse500_ShouldReturnServerError() {
        let response = HTTPURLResponse().makeURLResponseMock(with: 500)
        let result = sut.handle(data: nil, response: response, error: nil)
        switch result {
        case .success:
            XCTFail("Unexpected data!")
        case .failure(let error):
            XCTAssertEqual(error, .badRequest(500))
            XCTAssertEqual(error.localizedDescription, "Server error. Code: 500")
        }
    }
    
    func testHandle_WithoutResponse_ShouldReturnInvalidResponse() {
        let result = sut.handle(data: nil, response: nil, error: nil)
        switch result {
        case .success:
            XCTFail("Unexpected data!")
        case .failure(let error):
            XCTAssertEqual(error, .invalidResponse)
        }
    }
    
    func testHandle_WithError_ShouldReturnUrlErro() {
        let expectedError = URLError(.badURL)
        let result = sut.handle(data: nil, response: nil, error: expectedError)
        switch result {
        case .success:
            XCTFail("Unexpected data!")
        case .failure(let error):
            XCTAssertEqual(error, .urlError(expectedError))
        }
    }
}

extension HTTPError: Equatable {
    public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse): return true
        case let (.badRequest(rhsCode), .badRequest(lhsCode)): return rhsCode == lhsCode
        case (.decodingError, .decodingError): return true
        case let (.urlError(rhsError), .urlError(lhsError)): return rhsError == lhsError
        case (.invalidURL, .invalidURL): return true
        case (.invalidImageData, .invalidImageData): return true
        case (.unknowError, .unknowError): return true
        default: return false
        }
    }
}
