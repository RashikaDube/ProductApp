//
//  ProductDTO.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation
import SwiftUI

struct ProductDTO: Codable {
    
    // MARK: - Properties
    let id: Int
    let title: String
    let description: String? 
    let price: Double
    let thumbnail: String
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, title, price, thumbnail
        case description = "productDescription"
    }
}
