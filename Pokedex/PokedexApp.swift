//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Vitor Costa on 27/09/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            let repository = HomeRepository()
            let controller = HomeController(repository: repository)
            HomeView(controller: controller)
        }
    }
}
