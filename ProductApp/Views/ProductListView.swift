//
//  ProductListView.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import SwiftUI
import SwiftData

// Displays a list of products with navigation to product details
struct ProductListView: View {
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ProductViewModel
    
    // MARK: - Initializer
    init() {
        _viewModel = StateObject(wrappedValue: ProductViewModel(context: nil))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack(alignment: .top) {
                        AsyncImageView(url: product.thumbnail)
                            .frame(width: 60, height: 60)
                        VStack(alignment: .leading) {
                            Text(product.title).bold()
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
        }
        .onAppear {
            viewModel.setContext(modelContext)
            Task {
                await viewModel.loadProducts()
            }
        }
    }
}
