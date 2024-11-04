//
//  SignIn.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import SwiftUI

struct SignIn: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert: Bool = false
    @State private var isSecured: Bool = true
    
    var body: some View {
        VStack {
            Text("Dog24")
                .font(.largeTitle)
                .bold()
                .padding(.top, 36)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Anmelden")
                    .font(.title)
                    .padding(.top, 36)
                
                TextField("E-Mail", text: $email)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                passwordField("Passwort", text: $password, isSecured: $isSecured)
                
                Button(action: {
                    Task { await signIn() }
                }) {
                    Text("Anmelden")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Anmeldefehler"),
                        message: Text(viewModel.errorMessage ?? "Ein unbekannter Fehler ist aufgetreten."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)

            Spacer()
        }
    }
    
    private func signIn() async {
        do {
            try await viewModel.signIn(email: email, password: password)
            dismiss()
        } catch {
            viewModel.errorMessage = error.localizedDescription
            showingAlert = true
        }
    }

    @ViewBuilder
    private func passwordField(_ placeholder: String, text: Binding<String>, isSecured: Binding<Bool>) -> some View {
        ZStack(alignment: .trailing) {
            if isSecured.wrappedValue {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }
            Button(action: { isSecured.wrappedValue.toggle() }) {
                Image(systemName: isSecured.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    SignIn()
}
