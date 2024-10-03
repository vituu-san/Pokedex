//
//  DetailView.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import Foundation

import SwiftUI

struct DetailView<Controlling>: View where Controlling: DetailController {
    @StateObject var controller: Controlling
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(uiImage: controller.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
                
                DetailCardView(stats: controller.stats)
                
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(controller.name.capitalized)
        .onAppear() {
            controller.fetchImage()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let stats = [
            Pokemon.Stat(base: 35, value: Item(name: "HP", urlString: "")),
            Pokemon.Stat(base: 80, value: Item(name: "Attack", urlString: ""))
        ]
        let controller = DetailController(name: "Pikachu", urlString: "", stats: stats)
        DetailView(controller: controller)
    }
}
