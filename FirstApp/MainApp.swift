//
//  MainApp.swift
//  FirstApp
//
//  Created by Christos Condrea on 8/2/25.
//

import SwiftUI
import PresentationLayer

@main
struct MainApp: App {
    init() {
        Resolver.shared = Resolver(appDI: AppDIImpl.shared)
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
