//
//  ContentView.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
            FavoriteView()
                .tabItem {
                    Label("Gespeichert", systemImage: "heart")
                }
            SettingsView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
