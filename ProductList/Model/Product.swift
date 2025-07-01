//
//  Product.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import Foundation

struct Product: Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    
    var formattedPrice: String {
        String(format: "%.2f", price)
    }
}
