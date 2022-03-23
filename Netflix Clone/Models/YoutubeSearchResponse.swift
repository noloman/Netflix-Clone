//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Manu on 21/03/2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementId
}

struct VideoElementId: Codable {
    let kind: String
    let videoId: String
}
