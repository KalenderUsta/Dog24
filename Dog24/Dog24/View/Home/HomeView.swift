//
//  HomeView.swift
//  Dog24
//
//  Created by Kalender Usta on 11.09.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Dog24")
                        .font(.title)
                        .bold()
                }
                .padding()
                
                VStack {
                    NavigationLink(destination: ProduktListeView(title: viewModel.categorySpielzeuge.category.rawValue, products: viewModel.products.filter{ $0.category.category == .spielzeuge}).environmentObject(viewModel)) {
                        ZStack {
                            AsyncImage(url: URL(string: viewModel.categorySpielzeuge.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 300)
                                    .clipped()
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            
                            VStack {
                                Spacer()
                                Text(viewModel.categorySpielzeuge.category.rawValue)
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                    .bold()
                                    .shadow(radius: 5)
                            }
                            .padding()
                        }
                    }
                }
                
                SectionView(title: "Empfehlungen")
                    .onAppear {
                        Task {
                            await viewModel.fetchAllRecommended()
                        }
                    }
                SectionView(title: "Neuheiten")
                    .onAppear {
                        Task {
                            await viewModel.fetchAllNewArrivals()
                        }
                    }
                
                NavigationLink(destination: ProduktListeView(title: viewModel.categorySpielzeuge.category.rawValue, products: viewModel.products.filter{ $0.category.category == .futter}).environmentObject(viewModel)) {
                    ZStack {
                        AsyncImage(url: URL(string: viewModel.categoryFutter.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .clipped()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        
                        VStack {
                            Spacer()
                            Text(viewModel.categoryFutter.category.rawValue)
                                .font(.title)
                                .foregroundStyle(.blue)
                                .bold()
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
                
                SectionView(title: "Bestseller")
                    .onAppear {
                        Task {
                            await viewModel.fetchAllBestSellers()
                        }
                    }
                SectionView(title: "Beliebte Geschenke")
                    .onAppear {
                        Task {
                            await viewModel.fetchAllPopularGifts()
                        }
                    }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                            
                            if viewModel.isUserLoggedIn && viewModel.cartItemCount > 0 {
                                Text("\(viewModel.cartItemCount)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(.red, in: .circle)
                                    .overlay(
                                        Circle()
                                            .stroke(.white, lineWidth: 2)
                                    )
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewModel())
}
