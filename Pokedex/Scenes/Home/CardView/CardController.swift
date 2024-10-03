//
//  CardController.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation
import SwiftUI

protocol CardControlling: ObservableObject {
    var image: UIImage { get }
    var name: String { get }
    var number: Int { get }
    var colorName: String { get }
    var isLoading: Bool { get }
    
    func fetchImage()
    func fetchSpecie()
}

final class CardController: CardControlling {
    @Published var image: UIImage = UIImage()
    @Published var name: String = ""
    @Published var number: Int = 0
    @Published var colorName: String = ""
    @Published var isLoading: Bool = false
    
    private var urlImage: String
    private var specie: String
    
    private var repository: CardRepositoring
    
    init(urlImage: String, specie: String, name: String, number: Int, repository: CardRepositoring) {
        self.urlImage = urlImage
        self.specie = specie
        self.name = name
        self.number = number
        self.repository = repository
    }
    
    func fetchImage() {
        // TODO: Estados de imagem: Loading.
        isLoading = true
        repository.fetchImage(with: urlImage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
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
    
    func fetchSpecie() {
        isLoading = true
        repository.fetchSpecie(with: specie) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let specie):
                    self?.colorName = specie.color.name
                case .failure(let error):
                    // TODO: Estados de imagem: Erro.
                    debugPrint("Fetch Card Image. Description: \(error)")
                }
            }
        }
    }
}
