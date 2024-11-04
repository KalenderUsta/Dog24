//
//  ProductDetailView.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    @State private var selectedAmount: Int = 1
    @EnvironmentObject var viewModel: ViewModel
    @State private var showLoginOrRegisterAlert = false
    @State private var showLoginOrRegisterSheet = false
    @State private var isSignIn = true
    
    private var totalPrice: Double {
        return product.price * Double(selectedAmount)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                VStack {
                    AsyncImage(url: URL(string: product.bildUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .background(.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 0)
                .padding(.horizontal, 0)
                
                Text(product.title)
                    .font(.largeTitle)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Beschreibung:")
                        .padding(.top)
                    
                    Text(product.description)
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                }
                .padding(.horizontal)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 36)
                
                Stepper("Menge: \(selectedAmount)", value: $selectedAmount, in: 1...10)
                    .padding()
                
                if viewModel.isUserLoggedIn {
                    Button(action: {
                        viewModel.buyProduct(product, amount: selectedAmount)
                    }) {
                        Text("Kaufe \(selectedAmount) Stück")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(product.quantity > 0 ? .blue : .gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disabled(product.quantity == 0 || selectedAmount > 3)
                    }
                    .padding(.bottom, 16)
                } else {
                    Button(action: {
                        showLoginOrRegisterAlert = true
                    }) {
                        Text("Kaufe \(selectedAmount) Stück")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(product.quantity > 0 ? .blue : .gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disabled(product.quantity == 0 || selectedAmount > 3)
                    }
                    .padding(.bottom, 16)
                }
                
                if viewModel.isUserLoggedIn {
                    Button(action: {
                        let cartItem = CartItem(product: product, quantity: selectedAmount)
                        viewModel.addToCart(item: cartItem)
                    }) {
                        Text("In den Warenkorb")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.blue, lineWidth: 2)
                            )
                            .padding(.bottom, 32)
                    }
                } else {
                    Button(action: {
                        showLoginOrRegisterAlert = true
                    }) {
                        Text("In den Warenkorb")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.blue, lineWidth: 2)
                            )
                            .padding(.bottom, 32)
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Summe: \(String(format: "%.2f", totalPrice)) €")
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                }
                .padding(.bottom, 16)
                
                if !viewModel.recommendedProducts.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Vielleicht interessiert dich auch:")
                            .padding(.bottom, 8)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.recommendedProducts.shuffled().prefix(6), id: \.id) { recommendedProduct in
                                    NavigationLink(destination: ProductDetailView(product: recommendedProduct)) {
                                        VStack {
                                            if let url = URL(string: recommendedProduct.bildUrl) {
                                                AsyncImage(url: url) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipped()
                                                } placeholder: {
                                                    ProgressView()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                }
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            }
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(recommendedProduct.title)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                    .bold()
                                                    .lineLimit(1)
                                                Text(recommendedProduct.description)
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                                    .lineLimit(2)
                                                Text("\(String(format: "%.2f", recommendedProduct.price)) €")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                                    .padding(.vertical, 5)
                                            }
                                            .padding(.leading, 8)
                                        }
                                        .frame(width: 150, height: 200)
                                        .padding()
                                        .background(.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 5)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 24)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showLoginOrRegisterAlert) {
            Alert(
                title: Text("Nicht eingeloggt"),
                message: Text("Bitte melden Sie sich an oder registrieren Sie sich, um fortzufahren."),
                primaryButton: .default(Text("Login")) {
                    isSignIn = true
                    showLoginOrRegisterSheet = true
                },
                secondaryButton: .default(Text("Registrieren")) {
                    isSignIn = false
                    showLoginOrRegisterSheet = true
                }
            )
        }
        .sheet(isPresented: $showLoginOrRegisterSheet) {
            LoginOrRegisterSheet(isSignIn: $isSignIn)
        }
        .onChange(of: showLoginOrRegisterSheet) { newValue in
            if !newValue && viewModel.isUserLoggedIn == false {
                viewModel.isUserLoggedIn = true
            }
        }
        .padding(.horizontal)
    }
}
