//
//  NetworkMonitor.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import Network
import SwiftUI

// Monitors network connectivity status
final class NetworkMonitor: ObservableObject {
    
    // MARK: - Singleton
    static let shared = NetworkMonitor()
    
    // MARK: - Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    // MARK: - Initialization
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
