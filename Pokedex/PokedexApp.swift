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
            let networkService = NetworkService()
            let realmService = RealmService()
            let multiRequestService = MultiRequestService()
            let networkRepository = NetworkRepository(networkServicing: networkService,
                                                      multiRequestServicing: multiRequestService)
            let repository = HomeRepository(networkService: networkService,
                                            realmService: realmService,
                                            multiRequestService: multiRequestService,
                                            networkRepository: networkRepository)
            let controller = HomeController(repository: repository)
            HomeView(controller: controller)
        }
    }
}
