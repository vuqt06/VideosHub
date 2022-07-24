//
//  VideoModel.swift
//  VideosHub
//
//  Created by Vu Trinh on 7/23/22.
//

import Foundation
import Alamofire

class VideoModel: ObservableObject {
    @Published var videos = [Video]()
    
    init() {
        getVideos()
    }
    
    func getVideos() {
        // Create a URL object
        guard let url = URL(string: "\(Constants.API_URL)/playlistItems") else {
            return
        }
        
        // Get a decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        // Create a URL request
        AF.request(
            url,
            parameters: ["part": "snippet", "playlistId": Constants.PLAYLIST_ID, "key": Constants.API_KEY]
        )
        .validate()
        .responseDecodable(of: Response.self, decoder: decoder) { response in
            // Check that the call was successful
            switch response.result {
            case .success:
                break
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
            
            // Update the UI with the videos
            if let videos = response.value?.items {
                DispatchQueue.main.async {
                    self.videos = videos
                }
            }
        }
    }
}
