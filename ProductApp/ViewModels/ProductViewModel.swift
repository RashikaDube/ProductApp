//
//  ProductViewModel.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation
import SwiftUI
import SwiftData


// ViewModel that handles loading product data from API or local database
class ProductViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [Product] = []
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private var context: ModelContext?
    
    // MARK: - Initializer
    init(context: ModelContext?) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    // Allows context to be set after initialization if needed
    func setContext(_ newContext: ModelContext) {
        self.context = newContext
    }
    
    // Loads products either from API  or local DB
    @MainActor
    func loadProducts() async {
        guard let context else { return }

        isLoading = true
        let service = ProductService(context: context)

        do {
            let loadedProducts: [Product]
            if NetworkMonitor.shared.isConnected {
                loadedProducts = try await service.fetchProducts()
            } else {
                loadedProducts = service.loadLocalProducts()
            }

            self.products = loadedProducts  
        } catch {
            print("Failed to load products: \(error)")
        }

        isLoading = false
    }

}
