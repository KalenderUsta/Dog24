//
//  SignUp.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import SwiftUI

struct SignUp: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @State private var showingAlert: Bool = false
    @State private var isSecured: Bool = true
    @State private var isSecured2: Bool = true
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("Dog24")
                .font(.largeTitle)
                .bold()
                .padding(.top, 36)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Registrieren")
                    .font(.title)
                    .padding(.top, 36)

                TextField("Vorname", text: $firstName)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.top)

                TextField("Nachname", text: $lastName)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                
                TextField("E-Mail", text: $email)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)

                passwordField("Passwort", text: $password, isSecured: $isSecured)
                passwordField("Passwort bestätigen", text: $passwordCheck, isSecured: $isSecured2)
                
                Button(action: {
                    Task { await signUp() }
                }) {
                    Text("Registrieren")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Registrierfehler"),
                        message: Text(alertMessage),
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

    private func signUp() async {
        guard password == passwordCheck else {
            alertMessage = "Die Passwörter stimmen nicht überein."
            showingAlert = true
            return
        }
        
        do {
            try await viewModel.createUser(email: email, password: password, firstName: firstName, lastName: lastName)
            dismiss()
        } catch {
            alertMessage = error.localizedDescription
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
    SignUp()
}
