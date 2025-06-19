//
//  AsyncImageView.swift
//  ProductApp
//
//  Created by Neosoft on 16/06/25.
//

import SwiftUI
import Network

// MARK: - AsyncImageView with caching and offline support
struct AsyncImageView: View {
    
    // MARK: - Properties
    let url: String
    @State private var image: UIImage? = nil
    
    // MARK: - Body
    var body: some View {
        Group {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
        }
        .task {
            if image == nil {
                await loadImage()
            }
        }
    }
    
    // MARK: - Load Image from Cache or Network
    private func loadImage() async {
        // Try memory/disk cache first
        if let cached = ImageCache.shared.image(for: url) {
            self.image = cached
            return
        }
        
        // Check network availability
        guard await isNetworkAvailable() else {
            print("Offline and image not cached: \(url)")
            return
        }
        
        // Download and cache image
        guard let imgURL = URL(string: url) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imgURL)
            if let img = UIImage(data: data) {
                ImageCache.shared.setImage(img, for: url)
                self.image = img
            }
        } catch {
            print("Failed to load image from: \(url), error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Network Availability Check
    private func isNetworkAvailable() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "NetworkMonitor")
            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status == .satisfied)
                monitor.cancel()
            }
            monitor.start(queue: queue)
        }
    }
}

