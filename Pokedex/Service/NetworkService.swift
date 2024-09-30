//
//  NetworkService.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

protocol NetworkServicing {
    var urlSession: URLSessionProtocol { get }
    func fetch<T: Decodable>(type: T.Type,
                             endpoint: APIEndpoint,
                             parameters: [String: Any]?,
                             completion: @escaping (Result<T, HTTPError>) -> Void)
}

/// Responsável pelas requisições HTTP de toda a aplicação.
final class NetworkService: NetworkServicing {
    var urlSession: URLSessionProtocol
    
    private let httpHandler = HTTPHandler()
    private let decodeHandler = DecodeHandler()
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(type: T.Type,
                             endpoint: APIEndpoint,
                             parameters: [String: Any]? = nil,
                             completion: @escaping (Result<T, HTTPError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let urlRequest = makeURLRequest(url: url, method: .get, parameters: parameters)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let result = self?.httpHandler.handle(data: data, response: response, error: error) else {
                completion(.failure(.unknowError))
                return
            }
            
            switch result {
            case .success(let validData):
                if let object = self?.decodeHandler.handle(type, from: validData) {
                    completion(.success(object))
                } else {
                    completion(.failure(.unknowError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
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
