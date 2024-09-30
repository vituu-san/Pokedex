//
//  MultiRequestService.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

protocol MultiRequestServicing {
    var session: URLSessionProtocol { get }
    func performRequests(_ urls: [URL?], completion: @escaping ([Result<Data, HTTPError>]) -> Void)
}

/// Dispara multiplas requisições HTTP em diferentes threads, de forma assíncrona.
final class MultiRequestService: MultiRequestServicing {
    var session: URLSessionProtocol
    
    private let httpHandler = HTTPHandler()
    private var results = [Result<Data, HTTPError>]()
    
    private var networkService = NetworkService()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func performRequests(_ urls: [URL?], completion: @escaping ([Result<Data, HTTPError>]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "multiThread.queue", attributes: .concurrent)
        let resultQueue = DispatchQueue(label: "result.queue")
        
        for url in urls {
            dispatchGroup.enter()
            
            queue.async {
                guard let url else {
                    resultQueue.sync { self.results.append(.failure(.invalidURL)) }
                    return
                }
                
                let urlRequest = URLRequest(url: url)
                let task = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                    guard let result = self?.httpHandler.handle(data: data, response: response, error: error) else {
                        resultQueue.sync { self?.results.append(.failure(.unknowError)) }
                        return
                    }
                    
                    switch result {
                    case .success(let data):
                        resultQueue.sync { self?.results.append(.success(data)) }
                    case .failure(let error):
                        resultQueue.sync { self?.results.append(.failure(error)) }
                        debugPrint("Failure on URL request. URL: \(url) | Description: \(error)")
                    }
                    
                    dispatchGroup.leave()
                }
                
                task.resume()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(self.results)
        }
    }
}
