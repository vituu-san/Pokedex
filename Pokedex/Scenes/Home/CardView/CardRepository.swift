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
    private var imageDownloader = ImageDownloader()
    private var networkService: NetworkServicing
    
    init(imageDownloader: ImageDownloader = ImageDownloader(), networkService: NetworkServicing) {
        self.imageDownloader = imageDownloader
        self.networkService = networkService
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
        networkService.fetch(type: Specie.self,
                             endpoint: .specie(name), 
                             parameters: nil) { result in
            switch result {
            case .success(let specie):
                completion(.success(specie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
