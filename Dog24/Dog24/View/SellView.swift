//
//  SellView.swift
//  Dog24
//
//  Created by Kalender Usta on 11.10.24.
//

import SwiftUI

struct CardInfo {
    var number: String
    var expirationDate: String
    var cvv: String
}

struct SellView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var zipCode: String = ""
    @State private var selectedPaymentMethod: String = "Kreditkarte"
    
    @State private var cardNumber: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    
    @State private var isProcessing: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var showSuccessCheckmark: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    let paymentMethods = ["Kreditkarte", "PayPal", "Google Pay"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // Artikel im Warenkorb anzeigen
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.cartItems) { item in
                                NavigationLink(destination: ProductDetailView(product: item.product)) {
                                    VStack {
                                        if let url = URL(string: item.product.bildUrl) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(8)
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 100, height: 100)
                                                    .background(.gray.opacity(0.3))
                                                    .cornerRadius(8)
                                            }
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
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
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Lieferadresse Eingabe
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Lieferadresse")
                            .font(.title2)
                            .bold()
                        
                        TextField("Straße und Hausnummer", text: $street)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Stadt", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Postleitzahl", text: $zipCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Zahlungsmethode Auswahl
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Zahlungsmethode")
                            .font(.title2)
                            .bold()
                        
                        Picker("Zahlungsmethode", selection: $selectedPaymentMethod) {
                            ForEach(paymentMethods, id: \.self) { method in
                                Text(method).tag(method)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Eingabe für Kreditkarte
                    if selectedPaymentMethod == "Kreditkarte" {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Kreditkarteninformationen")
                                .font(.title3)
                                .bold()
                            
                            TextField("Kartennummer", text: $cardNumber)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Ablaufdatum (MM/YY)", text: $expirationDate)
                                .keyboardType(.numbersAndPunctuation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("CVV", text: $cvv)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                    }
                    // PayPal und Google Pay Buttons
                    else if selectedPaymentMethod == "PayPal" {
                        paymentButton(paymentMethod: "PayPal")
                    } else if selectedPaymentMethod == "Google Pay" {
                        paymentButton(paymentMethod: "Google Pay")
                    }
                    
                    Spacer()
                    
                    // Kauf Button
                    Button(action: {
                        if isInputIncomplete() {
                            errorMessage = selectedPaymentMethod == "Kreditkarte" ? "Bitte fülle alle Felder aus." : "Bitte fülle die Lieferadresse aus."
                            showErrorAlert = true
                        } else {
                            startPurchaseProcess()
                        }
                    }) {
                        Text("Jetzt kaufen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .disabled(isInputIncomplete())
                    .navigationTitle("Bestellung abschließen")
                }
            }
            
            // Floating für Fortschrittsanzeige und Haken-Symbol
            if isProcessing {
                VStack {
                    if showSuccessCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green)
                            .transition(.scale)
                    } else {
                        ProgressView("Bestellung wird bearbeitet...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // Zeigt den Haken nach 5 Sekunden
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showSuccessCheckmark = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    }
                    
                    // Entfernt das Overlay und leert den Warenkorb nach 2 Sekunden
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        withAnimation {
                            isProcessing = false
                            showConfirmation = true
                        }
                        clearShoppingCart()
                    }
                }
            }
        }
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Kauf erfolgreich"),
                message: Text("Deine Bestellung wurde erfolgreich abgeschlossen!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Fehler"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func isInputIncomplete() -> Bool {
        let trimmedStreet = street.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZipCode = zipCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCardNumber = cardNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedExpirationDate = expirationDate.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCVV = cvv.trimmingCharacters(in: .whitespacesAndNewlines)

        if selectedPaymentMethod == "Kreditkarte" {
            return trimmedStreet.isEmpty || trimmedCity.isEmpty || trimmedZipCode.isEmpty || trimmedCardNumber.isEmpty || trimmedExpirationDate.isEmpty || trimmedCVV.isEmpty
        } else {
            return trimmedStreet.isEmpty || trimmedCity.isEmpty || trimmedZipCode.isEmpty
        }
    }
    
    func startPurchaseProcess() {
        guard !isInputIncomplete() else {
            showErrorAlert = true
            return
        }

        isProcessing = true
        showSuccessCheckmark = false
    }
    
    func clearShoppingCart() {
        viewModel.clearShoppingCart()
    }
    
    // Funktion zur Erstellung des Zahlungsbuttons
    @ViewBuilder
    private func paymentButton(paymentMethod: String) -> some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Mit \(paymentMethod) bezahlen")
                .font(.title3)
                .bold()
            
            Button(action: {
                print("\(paymentMethod) Login gestartet")
            }) {
                Text("Mit \(paymentMethod) anmelden")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SellView()
        .environmentObject(ViewModel())
}
