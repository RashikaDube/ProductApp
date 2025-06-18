//
//  ProductResponse.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation

// Response model for the products API
struct ProductResponse: Codable {
    
    // MARK: - Properties

    let products: [ProductDTO]
}
