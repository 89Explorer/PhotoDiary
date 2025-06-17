//
//  Manager.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/17/25.
//

import Foundation


final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    var cachedImageURLs: [Int: URL] = [:]
    
    func preloadImages(forDays days: Int) {
        for day in 1...days {
            if cachedImageURLs[day] == nil {
                if let url = URL(string: "https://picsum.photos/200/300?random=\(UUID().uuidString)") {
                    cachedImageURLs[day] = url
                }
            }
        }
    }
    
    func url(for day: Int) -> URL? {
        return cachedImageURLs[day]
    }
}
