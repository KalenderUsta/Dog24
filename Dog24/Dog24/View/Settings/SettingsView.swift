//
//  ProfileView.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showLoginOrRegisterSheet = false
    @State private var isSignIn = true // Steuert, ob Anmelden oder Registrieren angezeigt wird
    @State private var showPrivacySheet = false
    @State private var showFAQSheet = false
    @State private var showLegalInfoSheet = false
    @State private var showProfileSheet = false
    @State private var languages: [String] = ["Deutsch"]
    @State private var languagePicker = "Deutsch"
    @State private var countries: [String] = ["Deutschland"]
    @State private var landPicker = "Deutschland"

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profil").font(.headline)) {
                    Button(action: {
                        showProfileSheet = true
                    }) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("Profil")
                        }
                    }
                    .sheet(isPresented: $showProfileSheet) {
                        ProfileView()
                    }
                }

                Section(header: Text("Sprachen und Region").font(.headline)) {
                    Picker("Sprache", selection: $languagePicker) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    Picker("Land", selection: $landPicker) {
                        ForEach(countries, id: \.self) { country in
                            Text(country)
                        }
                    }
                }

                Section(header: Text("Hilfe und Support").font(.headline)) {
                    Button(action: {
                        showPrivacySheet = true
                    }) {
                        HStack {
                            Image(systemName: "lock.shield")
                            Text("Datenschutz")
                        }
                    }
                    .sheet(isPresented: $showPrivacySheet) {
                        PrivacyView()
                    }

                    Button(action: {
                        showFAQSheet = true
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("FAQ")
                        }
                    }
                    .sheet(isPresented: $showFAQSheet) {
                        FAQView()
                    }

                    Button(action: {
                        showLegalInfoSheet = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Rechtsinfos")
                        }
                    }
                    .sheet(isPresented: $showLegalInfoSheet) {
                        LegalInfoView()
                    }
                }

                Section(header: Text("Benutzerkonto").font(.headline)) {
                    if viewModel.isUserLoggedIn {
                        Text("Willkommen, \(viewModel.profile?.name ?? "User")!")
                            .font(.headline)
                        
                        Button(action: {
                            Task {
                                try await viewModel.signOut()
                            }
                        }) {
                            Text("Abmelden")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.red)
                                .cornerRadius(10)
                        }
                    } else {
                        HStack {
                            Button(action: {
                                isSignIn = true // Anmelden auswählen
                                showLoginOrRegisterSheet = true // Sheet anzeigen
                            }) {
                                Text("Anmelden")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }

                            Button(action: {
                                isSignIn = false // Registrieren auswählen
                                showLoginOrRegisterSheet = true // Sheet anzeigen
                            }) {
                                Text("Registrieren")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.green)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .sheet(isPresented: $showLoginOrRegisterSheet) {
                LoginOrRegisterSheet(isSignIn: $isSignIn) // Zeige das Login/Registrierungs Sheet
                    .environmentObject(viewModel)
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ViewModel())
}
