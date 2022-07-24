//
//  VideoPreview.swift
//  VideosHub
//
//  Created by Vu Trinh on 7/23/22.
//

import Foundation
import Alamofire

class VideoPreview: ObservableObject {
    @Published var thumbnailData = Data()
    @Published var title: String
    @Published var date: String
    
    var video: Video
    
    init(video: Video) {
        // Set the video and title
        self.video = video
        self.title = video.title
        
        // Set the date
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        self.date = df.string(from: video.published)
        
        // Download the image data
        guard video.thumbnail != "" else {
            return
        }
        
        // Check cache before dowloading data
        if let cacheData = CacheManager.getVideoCache(video.thumbnail) {
            // Set the thumbnail data
            self.thumbnailData = cacheData
            return
        }
        
        // Get a url from the thumbnail
        guard let url = URL(string: video.thumbnail) else {
            return
        }
        
        // Create the reuuest
        AF.request(url)
            .validate()
            .responseData { response in
                if let data = response.data {
                    // Save the data in the cache
                    CacheManager.setVideoCache(video.thumbnail, data)
                    
                    // Set the image
                    DispatchQueue.main.async {
                        self.thumbnailData = data
                    }
                }
            }
    }
}
