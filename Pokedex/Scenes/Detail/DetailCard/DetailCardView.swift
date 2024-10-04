//
//  DetailCardView.swift
//  Pokedex
//
//  Created by Vitor Costa on 02/10/24.
//

import SwiftUI

struct DetailCardView: View {
    var stats: [Pokemon.Stat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(stats, id: \.self) { item in
                HStack {
                    Text(item.value.name)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(item.base)")
                        .font(.body).bold()
                }
                Divider()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct DetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        let stats = [
            Pokemon.Stat(base: 35, value: Item(name: "HP", urlString: "")),
            Pokemon.Stat(base: 80, value: Item(name: "Attack", urlString: ""))
        ]
        
        DetailCardView(stats: stats)
    }
}
