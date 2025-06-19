//
//  ProductDataManager.swift
//  ProductApp
//
//  Created by Neosoft on 18/06/25.
//

// Handles all local CRUD operations for Product using SwiftData

import Foundation
import SwiftData

final class ProductDataManager {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Save
    func save(products: [Product]) throws {
        for product in products {
            context.insert(product)
        }
        try context.save()
        print("Saved \(products.count) products")
    }
    
    // MARK: - Fetch
    func fetchAllProducts() -> [Product] {
        (try? context.fetch(FetchDescriptor<Product>())) ?? []
    }
    
    // MARK: - Delete All
    func deleteAllProducts() throws {
        let products = fetchAllProducts()
        for product in products {
            context.delete(product)
        }
        try context.save()
    }
    
    // MARK: - Optional: Replace all (delete + insert)
    func replaceAllProducts(with products: [Product]) throws {
        try deleteAllProducts()
        try save(products: products)
    }
}
