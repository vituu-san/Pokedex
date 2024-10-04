//
//  MultiRequestService.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

protocol MultiRequestServicing {
    func performRequests(_ urls: [URL?], completion: @escaping ([Result<Data, HTTPError>]) -> Void)
}

/// Dispara multiplas requisições HTTP em diferentes threads, de forma assíncrona.
final class MultiRequestService: MultiRequestServicing {
    private let networkService: NetworkServicing
    private var results = [Result<Data, HTTPError>]()
    
    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }
    
    func performRequests(_ urls: [URL?], completion: @escaping ([Result<Data, HTTPError>]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "multiThread.queue", attributes: .concurrent)
        let resultQueue = DispatchQueue(label: "result.queue")
        
        for url in urls {
            dispatchGroup.enter()
            
            queue.async { [weak self] in
                self?.networkService.fetch(endpoint: .custom(url), parameters: nil) { [weak self] result in
                    switch result {
                    case .success(let data):
                        resultQueue.sync { self?.results.append(.success(data)) }
                    case .failure(let error):
                        resultQueue.sync { self?.results.append(.failure(error)) }
                        debugPrint("Failure on URL request. URL: \(String(describing: url)) | Description: \(error)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(self.results)
            }
        }
    }
}
