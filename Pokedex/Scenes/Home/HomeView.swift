//
//  HomeView.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import SwiftUI

struct HomeView<Controlling>: View where Controlling: HomeControlling {
    @StateObject var controller: Controlling
    
    @State private var hasAppearedOnce = false
    @State private var searchText = ""
    
    var filteredItems: [Pokemon] {
        if searchText.isEmpty {
            return controller.pokemons
        } else {
            return controller.pokemons.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if controller.isLoading {
                        ProgressView("Loading...")
                    } else {
                        
                        Image("pokemon-banner")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .padding([.top, .horizontal])
                        
                        HStack {
                            TextField("Search", text: $searchText)
                                .padding(.leading, 12)
                                .frame(height: 40)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 16)
                        
                        if controller.isLoading {
                            ProgressView()
                        } else {
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(filteredItems, id: \.self) { item in
                                    let networkService = NetworkService()
                                    let cardRepository = CardRepository(networkService: networkService)
                                    let controller = CardController(urlImage: item.sprites.front,
                                                                    specie: item.species.name,
                                                                    name: item.name,
                                                                    number: item.id,
                                                                    repository: cardRepository)
                                    
                                    
                                    let detailController = DetailController(name: item.name, 
                                                                            
                                                                            urlString: item.sprites.front,
                                                                            stats: item.stats)
                                    NavigationLink(destination: DetailView(controller: detailController)) {
                                        CardView(controller: controller)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .onAppear {
                if !hasAppearedOnce {
                    controller.fetchPokemonsList(at: 9)
                    hasAppearedOnce = true
                }
            }
            .onDisappear() {
                hasAppearedOnce = false
            }
        }
    }
}
