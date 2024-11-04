//
//  LoginOrRegisterSheet.swift
//  Dog24
//
//  Created by Kalender Usta on 23.09.24.
//

import SwiftUI

struct LoginOrRegisterSheet: View {
    @Binding var isSignIn: Bool

    var body: some View {
        VStack {
            if isSignIn {
                SignIn()
            } else {
                SignUp()
            }
            
            HStack {
                Text(isSignIn ? "Noch keinen Account?" : "Schon einen Account?")
                Button(action: {
                    isSignIn.toggle()
                }) {
                    Text(isSignIn ? "Registrieren" : "Login")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding() 
    }
}
