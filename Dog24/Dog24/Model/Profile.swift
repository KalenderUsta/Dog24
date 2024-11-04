//
//  Profile.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import Foundation

struct Profile: Identifiable, Codable {
    var id: String
    var email: String
    var name: String?
    var imageUrl: String?
    var uid: String
    
    init(email: String, name: String? = nil, imageUrl: String? = nil, uid: String) {
        self.id = uid
        self.email = email
        self.name = name
        self.imageUrl = imageUrl
        self.uid = uid
    }
}
