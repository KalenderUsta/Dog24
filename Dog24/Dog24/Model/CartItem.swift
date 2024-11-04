//
//  CartItem.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let product: Product
    var quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case product
        case quantity
    }
}
