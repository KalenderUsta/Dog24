//
//  PrivacyView.swift
//  Dog24
//
//  Created by Kalender Usta on 23.09.24.
//

import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Datenschutzhinweise")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("""
                    Wir nehmen den Schutz Ihrer persönlichen Daten sehr ernst. Diese Datenschutzerklärung erläutert, welche Informationen wir erheben und wie wir diese nutzen.
                    
                    1. **Daten, die wir sammeln:**
                    - Name, E-Mail-Adresse und weitere Informationen, die Sie bei der Registrierung angeben.
                    - Nutzungsdaten, die bei der Verwendung unserer App entstehen (z.B. Log-Daten).
                    
                    2. **Wie wir Ihre Daten verwenden:**
                    - Um Ihnen Zugang zu unseren Diensten zu bieten und diese zu verbessern.
                    - Zur Analyse der Nutzung und Verbesserung der App-Performance.
                    
                    3. **Weitergabe an Dritte:**
                    - Ihre Daten werden nur im Rahmen der gesetzlichen Vorgaben an Partner weitergegeben, z.B. zur Zahlungsabwicklung.
                    
                    4. **Ihre Rechte:**
                    - Sie haben das Recht auf Auskunft über Ihre gespeicherten Daten sowie das Recht, deren Löschung zu verlangen.
                    """)
                    .padding()

                Text("Für weitere Informationen oder Fragen wenden Sie sich bitte an unseren Support.")
                    .padding(.top, 10)

                Spacer()
            }
            .navigationTitle("Datenschutz")
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
    PrivacyView()
}
