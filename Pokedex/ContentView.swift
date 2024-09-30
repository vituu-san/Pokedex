//
//  ContentView.swift
//  Pokedex
//
//  Created by Vitor Costa on 27/09/24.
//

import SwiftUI

struct ContentView: View {
    let networkService = NetworkService()
    let multiRequestService = MultiRequestService()
    let httpHandler = HTTPHandler()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            networkService.fetch(type: Pokemons.self, endpoint: .pokemons) { result in
                switch result {
                case .success(let pokemons):
                    let urls = pokemons.results.map({ URL(string: $0.urlString)! })
                    var count = 0
                    multiRequestService.performRequests(urls) { results in
                        for result in results {
                            count += 1
                            
                            print("Request \(count):")
                            switch result {
                            case .success(let pokemon):
                                let prettyData = NSString(data: pokemon, encoding: String.Encoding.utf8.rawValue)
                                print(prettyData ?? "No description.")
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            print("\n")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
