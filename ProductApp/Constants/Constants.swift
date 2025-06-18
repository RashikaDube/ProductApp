//
//  Constants.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation

struct Constants {
    
    // MARK: - API
    
    // The base URL of the dummy API
    static let baseURL = "https://dummyjson.com"
    
    // Endpoint path for fetching products
    static let productsEndpoint = "/products"
    
    // MARK: - Configuration
    
    // Default timeout interval for network requests
    static let timeoutInterval: TimeInterval = 30
}

