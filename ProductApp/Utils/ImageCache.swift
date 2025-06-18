//
//  ImageCache.swift
//  ProductApp
//  Created by Neosoft on 16/06/25.
//

import UIKit

// A simple in-memory image cache using NSCache
final class ImageCache {
    
    // MARK: - Singleton
    static let shared = ImageCache()
    
    // MARK: - Properties
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    // MARK: - Public Methods
    func image(for url: String) -> UIImage? {
        // Memory cache
        if let image = memoryCache.object(forKey: url as NSString) {
            return image
        }
        
        // Disk cache
        let fileURL = cacheDirectory.appendingPathComponent(cacheFileName(from: url))
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: url as NSString)
            return image
        }
        
        return nil
    }
    
    func setImage(_ image: UIImage, for url: String) {
        memoryCache.setObject(image, forKey: url as NSString)
        
        let fileURL = cacheDirectory.appendingPathComponent(cacheFileName(from: url))
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
    
    private func cacheFileName(from url: String) -> String {
        // Create safe filename
        return url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
    }
}

