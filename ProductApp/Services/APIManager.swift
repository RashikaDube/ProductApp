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
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch let urlError as URLError {
                // Handle specific URL errors
                print("URL Error: \(urlError)")
                throw urlError
            } catch let decodingError as DecodingError {
                // Handle JSON decoding issues
                print("Decoding Error: \(decodingError)")
                throw decodingError
            } catch {
                // Handle any other unknown errors
                print("Unexpected Error: \(error)")
                throw error
            }
        }
    }
