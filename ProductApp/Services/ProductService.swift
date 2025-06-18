//
//  ProductService.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation
import SwiftData
import Network

final class ProductService {
    
    // MARK: - Properties
    let modelContext: ModelContext
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    // MARK: - Initialization
    init(context: ModelContext) {
        self.modelContext = context
        monitor.start(queue: queue)
    }
    
    // MARK: - Public Methods
    // Automatically handles offline case: loads local data if needed
    func fetchProducts() async throws -> [Product] {
        
        //  Check for network connectivity
        let status = monitor.currentPath.status
        if status == .satisfied {
            print("Offline – loading products from local DB")
            return loadLocalProducts()
        }
        
        do {
            let response: ProductResponse = try await APIManager.shared.fetchData(from: Constants.productsEndpoint)
            
            print("API returned: \(response.products.count) products")
            
            var savedProducts: [Product] = []
            
            for dto in response.products {
                guard let product = createProduct(from: dto) else {
                    print(" Skipped product with ID \(dto.id) due to invalid data")
                    continue
                }
                
                modelContext.insert(product)
                savedProducts.append(product)
            }
            
            try modelContext.save()
            print(" Saved \(savedProducts.count) products")
            
            return savedProducts
        } catch {
            print("Failed to fetch or save products: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Loads products from local database using SwiftData
    func loadLocalProducts() -> [Product] {
        let products = (try? modelContext.fetch(FetchDescriptor<Product>())) ?? []
        print("Loaded \(products.count) products from local DB")
        return products
    }
    
    // MARK: - Private Helpers
    private func createProduct(from dto: ProductDTO) -> Product? {
        guard !dto.title.isEmpty,
              !dto.thumbnail.isEmpty else {
            return nil
        }
        
        return Product(
            id: dto.id,
            title: dto.title,
            productDescription: dto.description ?? "No description",
            price: dto.price,
            thumbnail: dto.thumbnail
        )
    }
}
