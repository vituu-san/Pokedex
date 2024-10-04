//
//  NetworkService.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

protocol NetworkServicing {
    func fetch(endpoint: APIEndpoint, 
               parameters: [String: Any]?,
               completion: @escaping (Result<Data, HTTPError>) -> Void)
}

/// Responsável pelas requisições HTTP de toda a aplicação.
final class NetworkService: NetworkServicing {
    var urlSession: URLSessionProtocol
    
    private let httpHandler: HTTPHandling
    
    init(urlSession: URLSessionProtocol = URLSession.shared, httpHandler: HTTPHandling = HTTPHandler()) {
        self.urlSession = urlSession
        self.httpHandler = httpHandler
    }
    
    func fetch(endpoint: APIEndpoint, 
               parameters: [String: Any]? = nil,
               completion: @escaping (Result<Data, HTTPError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let urlRequest = makeURLRequest(url: url, method: .get, parameters: parameters)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.httpHandler.handle(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func makeURLRequest(url: URL, method: APIEndpoint.HTTPMethod, parameters: [String: Any]?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            switch method {
            case .get:
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
                urlRequest.url = components?.url
            }
        }
        
        return urlRequest
    }
}
