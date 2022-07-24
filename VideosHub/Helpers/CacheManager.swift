//
//  CacheManager.swift
//  VideosHub
//
//  Created by Vu Trinh on 7/23/22.
//

import Foundation

class CacheManager {
    static var cache = [String: Data]()
    
    static func setVideoCache(_ url: String, _ data: Data?) {
        // Store the image data with the url as the key
        cache[url] = data
    }
    
    static func getVideoCache(_ url: String) -> Data? {
        return cache[url]
    }
}
