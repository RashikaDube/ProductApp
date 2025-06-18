//
//  APIManager.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Foundation

// Handles API requests throughout the app
final class APIManager {
    
    // MARK: - Singleton
    
    static let shared = APIManager()
    private init() {}
    
    // MARK: - Networking
    
    func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        guard let url = URL(string: Constants.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Constants.timeoutInterval
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
