//
//  Product.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation
import SwiftData


@Model
final class Product {
    
    // MARK: - Properties
    @Attribute(.unique) var id: Int
    var title: String
    var productDescription: String
    var price: Double
    var thumbnail: String
    
    // MARK: - Initialization
    
    // Main initializer
    init(id: Int, title: String, productDescription: String, price: Double, thumbnail: String) {
        self.id = id
        self.title = title
        self.productDescription = productDescription
        self.price = price
        self.thumbnail = thumbnail
    }
    
    // Initialize from DTO
    convenience init(from dto: ProductDTO) {
        self.init(
            id: dto.id,
            title: dto.title,
            productDescription: dto.description ?? "",
            price: dto.price,
            thumbnail: dto.thumbnail
        )
    }
}
