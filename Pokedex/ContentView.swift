//
//  ContentView.swift
//  Pokedex
//
//  Created by Vitor Costa on 27/09/24.
//

import SwiftUI

struct ContentView<Controlling>: View where Controlling: HomeControlling {
    @StateObject var controller: Controlling
    
//    init(controller: Controlling) {
//        self.controller = controller
//    }
    
    var body: some View {
        VStack {
            if controller.isLoading {
                ProgressView("Loading...")
            } else {
//                List(controller.pokemons) { pokemon in
//                    Text(pokemon.name)
//                }
            }
        }
        .padding()
        .onAppear {
            controller.fetchPokemonsList(at: 2)
        }
    }
}
