//
//  CardView.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import SwiftUI

struct CardView<Controlling>: View where Controlling: CardControlling {
    @StateObject var controller: Controlling
    
    var body: some View {
        VStack {
            Image(uiImage: controller.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(8)
            
            HStack(spacing: 10) {
                Text("#0\(controller.number)")
                Text(controller.name.capitalized)
            }
            .font(.system(size: 18))
            .foregroundColor(.black)
            .lineLimit(1)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 6, height: 6)))
            .padding(.bottom)
            .padding(.horizontal, 8)
        }
        .background(Color(controller.colorName))
        .frame(minWidth: 100, minHeight: 100)
        .cornerRadius(16)
        .shadow(radius: 1)
        .onAppear() {
            controller.fetchImage()
            controller.fetchSpecie()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = HomeRepository()
        let controller = HomeController(repository: repository)
        HomeView(controller: controller)
    }
}
