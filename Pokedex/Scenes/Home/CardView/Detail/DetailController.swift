//
//  DetailController.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import UIKit

protocol DetailControlling: ObservableObject {
    var image: UIImage { get }
    var stats: [Pokemon.Stat] { get }
    func fetchImage()
}

final class DetailController: DetailControlling {
    var name: String
    var urlString: String
    var stats: [Pokemon.Stat]

    @Published var image: UIImage = UIImage()

    private var imageDownloader: ImageDownloading = ImageDownloader()
    
    init(imageDownloader: ImageDownloading = ImageDownloader(),
         name: String,
         urlString: String,
         stats: [Pokemon.Stat]) {
        self.name = name
        self.imageDownloader = imageDownloader
        self.urlString = urlString
        self.stats = stats
    }
    
    func fetchImage() {
        imageDownloader.downloadImage(from: urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(let error):
                    // TODO: Estados de imagem: Erro.
                    debugPrint("Fetch Card Image. Description: \(error)")
                }
            }
        }
    }
}
