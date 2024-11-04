//
//  CartView.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showErrorAlert = false
    @State private var showLoginView = false
    @State private var navigateToCheckout = false
    
    private var totalPrice: Double {
        viewModel.cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if !viewModel.isUserLoggedIn {
                        Spacer()
                        Text("Bitte melde dich an, um auf deinen Warenkorb zuzugreifen.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        if viewModel.cartItems.isEmpty {
                            Spacer()
                            Text("Dein Warenkorb ist leer")
                                .font(.title2)
                                .padding()
                            Spacer()
                        } else {
                            ForEach(viewModel.cartItems) { item in
                                NavigationLink(destination: ProductDetailView(product: item.product)) {
                                    HStack {
                                        if let url = URL(string: item.product.bildUrl) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(8)
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 60, height: 60)
                                                    .background(.gray.opacity(0.3))
                                                    .cornerRadius(8)
                                            }
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .background(.gray.opacity(0.3))
                                                .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.product.title)
                                                .font(.headline)
                                                .foregroundStyle(.black)
                                                .multilineTextAlignment(.leading)
                                            Text("\(String(format: "%.2f", item.product.price)) €")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            Text("Menge: \(item.quantity)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.decreaseQuantityOrRemove(item: item)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            
            if !viewModel.isUserLoggedIn {
                Button(action: {
                    showLoginView.toggle()
                }) {
                    Text("Jetzt anmelden")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding()
                .padding(.bottom, 40)
            } else if viewModel.cartItems.isEmpty == false {
                VStack(spacing: 16) {
                    HStack {
                        Text("Gesamtsumme:")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text("\(String(format: "%.2f", totalPrice)) €")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: SellView(), isActive: $navigateToCheckout) {
                        Button(action: {
                            navigateToCheckout = true
                        }) {
                            Text("Jetzt kaufen")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .navigationTitle("Warenkorb")
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Fehler"),
                message: Text(viewModel.errorMessage ?? "Unbekannter Fehler"),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showLoginView) {
            SignIn()
        }
    }
}

#Preview {
    CartView()
        .environmentObject(ViewModel())
}
