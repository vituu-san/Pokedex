//
//  ImageDownloader.swift
//  Pokedex
//
//  Created by Vitor Costa on 30/09/24.
//

import UIKit

protocol ImageDownloading {
    var session: URLSessionProtocol { get }
    func cache(image: UIImage, with key: String)
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, HTTPError>) -> Void)
}

final class ImageDownloader: ImageDownloading {
    var session: URLSessionProtocol
    
    private let cache = NSCache<NSString, UIImage>()
    private let httpHandler = HTTPHandler()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func cache(image: UIImage, with key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, HTTPError>) -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let result = self?.httpHandler.handle(data: data, response: response, error: error) else {
                completion(.failure(.unknowError))
                return
            }
            
            switch result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    self?.cache.setObject(image, forKey: urlString as NSString)
                    completion(.success(image))
                } else {
                    completion(.failure(.invalidImageData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
