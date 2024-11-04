//
//  FAQView.swift
//  Dog24
//
//  Created by Kalender Usta on 23.09.24.
//

import SwiftUI

struct FAQView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("FAQ")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("""
                    Hier sind einige der häufig gestellten Fragen und Antworten zu unserer App:
                    
                    **1. Wie kann ich mich registrieren?**
                    - Um sich zu registrieren, klicken Sie auf „Registrieren“ und folgen Sie den Anweisungen. Sie benötigen eine gültige E-Mail-Adresse und ein Passwort.
                    
                    **2. Was mache ich, wenn ich mein Passwort vergessen habe?**
                    - Klicken Sie auf „Passwort vergessen?“ auf der Anmeldeseite und folgen Sie den Anweisungen, um ein neues Passwort zu erstellen.
                    
                    **3. Wie kann ich mein Konto löschen?**
                    - Um Ihr Konto zu löschen, kontaktieren Sie bitte unseren Support über die Einstellungen in der App.
                    
                    **4. Ist die Nutzung der App kostenlos?**
                    - Die Basisfunktionen der App sind kostenlos, es gibt jedoch kostenpflichtige Zusatzfunktionen.
                    
                    Weitere Fragen? Kontaktieren Sie uns jederzeit über den Support-Bereich der App.
                    """)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("FAQ")
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
    FAQView()
}
