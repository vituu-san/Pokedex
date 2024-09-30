//
//  URLSessionMock.swift
//  PokedexTests
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

@testable import Pokedex

final class URLSessionMock: URLSessionProtocol {
    private let dataTask = URLSessionDataTaskMock()
    
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(data, response, error)
        
        return dataTask
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() { }
}
