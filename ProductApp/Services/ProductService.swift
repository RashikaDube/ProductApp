//
//  ProductService.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//


import Foundation
import Network

final class ProductService {
    
    // MARK: - Properties
    private let dataManager: ProductDataManager
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    // MARK: - Initialization
    init(dataManager: ProductDataManager) {
        self.dataManager = dataManager
        monitor.start(queue: queue)
    }
    
    // MARK: - Public Methods
    func fetchProducts() async throws -> [Product] {
        let status = monitor.currentPath.status
        
        if status != .satisfied {
            print("Offline – loading from local DB")
            return dataManager.fetchAllProducts()
        }
        
        do {
            let response: ProductResponse = try await APIManager.shared.fetchData(from: Constants.productsEndpoint)
            print("API returned: \(response.products.count) products")
            
            let products = response.products.compactMap(createProduct)
            try dataManager.replaceAllProducts(with: products)
            return products
            
        } catch {
            print("Failed to fetch/save products: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadLocalProducts() -> [Product] {
        dataManager.fetchAllProducts()
    }
    
    // MARK: - DTO Conversion
    private func createProduct(from dto: ProductDTO) -> Product? {
        guard !dto.title.isEmpty, !dto.thumbnail.isEmpty else {
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
