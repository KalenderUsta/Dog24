//
//  Product.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import Foundation

struct Product: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var category: Category
    var evaluation: Int
    var price: Double
    var description: String
    var bildUrl: String
    var quantity: Int
    
    mutating func reduceQuantity(by amount: Int) {
        quantity = max(quantity - amount, 0)
    }
}
