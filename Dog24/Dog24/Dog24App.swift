//
//  Dog24App.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import SwiftUI
import Firebase

@main
struct Dog24App: App {
    @StateObject private var viewModel = ViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
