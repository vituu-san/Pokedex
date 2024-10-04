//
//  CardRepository.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import UIKit

protocol CardRepositoring: CardRepository {
    func fetchImage(with urlString: String, completion: @escaping (Result<UIImage, HTTPError>) -> Void)
    func fetchSpecie(with name: String, completion: @escaping (Result<Specie, HTTPError>) -> Void)
}

final class CardRepository: CardRepositoring {
    private var networkService: NetworkServicing
    private var imageDownloader: ImageDownloading
    private var decodeHandler: DecodeHandling
    
    init(networkService: NetworkServicing = NetworkService(),
         imageDownloader: ImageDownloading = ImageDownloader(),
         decodeHandler: DecodeHandling = DecodeHandler()) {
        self.networkService = networkService
        self.imageDownloader = imageDownloader
        self.decodeHandler = decodeHandler
    }
    
    func fetchImage(with urlString: String, completion: @escaping (Result<UIImage, HTTPError>) -> Void) {
        imageDownloader.downloadImage(from: urlString) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSpecie(with name: String, completion: @escaping (Result<Specie, HTTPError>) -> Void) {
        networkService.fetch(endpoint: .specie(name), parameters: nil) { [weak self] result in
            switch result {
            case .success(let data):
                if let specie = self?.decodeHandler.handle(Specie.self, from: data) {
                    completion(.success(specie))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
