//
//  ProductApp.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import SwiftUI
import SwiftData

// Entry point of the ProductApp
@main
struct ProductApp: App {
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            
            // Load the main product list screen
            ProductListView()
        }
        
        // Provide SwiftData container for the Product model
        .modelContainer(for: Product.self)
    }
}
