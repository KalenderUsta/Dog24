//
//  LegalInfoView.swift
//  Dog24
//
//  Created by Kalender Usta on 23.09.24.
//

import SwiftUI

struct LegalInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Rechtsinformationen")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("""
                    In dieser Sektion finden Sie wichtige rechtliche Informationen zu unserer App und unseren Diensten:
                    
                    **1. Nutzungsbedingungen:**
                    - Durch die Nutzung dieser App stimmen Sie unseren Nutzungsbedingungen zu. Diese regeln die Bedingungen, unter denen Sie unsere Dienste verwenden dürfen.
                    
                    **2. Haftungsausschluss:**
                    - Wir übernehmen keine Haftung für Schäden, die durch die Nutzung der App entstehen könnten, es sei denn, sie beruhen auf Vorsatz oder grober Fahrlässigkeit.
                    
                    **3. Urheberrecht:**
                    - Der gesamte Inhalt der App, einschließlich Texte, Bilder und Grafiken, unterliegt dem Urheberrecht und darf ohne unsere Zustimmung nicht verwendet werden.
                    
                    **4. Anwendbares Recht:**
                    - Diese Vereinbarung unterliegt den Gesetzen des Landes, in dem Sie die App verwenden. Gerichtsstand ist der Unternehmenssitz.
                    
                    **5. Änderungen an den Rechtsinformationen:**
                    - Wir behalten uns das Recht vor, diese Bedingungen jederzeit zu ändern. Die geänderten Bedingungen werden in der App veröffentlicht.
                    """)
                    .padding()

                Spacer()
            }
            .navigationTitle("Rechtsinfos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    LegalInfoView()
}
