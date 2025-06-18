//
//  ProductDetailView.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import SwiftUI

// Displays detailed view of a selected product
struct ProductDetailView: View {
    
    // MARK: - Properties
    let product: Product
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Product image
                AsyncImageView(url: product.thumbnail)
                    .frame(height: 200)
                    .clipped()
                
                // Product title
                Text(product.title).font(.title).bold()
                
                // Product price
                Text("Price: $\(product.price, specifier: "%.2f")")
                    .font(.headline)
            }.padding()
        }
        .navigationTitle("Details")
    }
}
