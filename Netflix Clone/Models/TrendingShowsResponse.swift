//
//  TrendingShowsResponse.swift
//  Netflix Clone
//
//  Created by Manu on 12/03/2022.
//

import Foundation

// MARK: - TrendingShowsResponse
struct TrendingShowsResponse: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

enum MediaType: String, Codable {
    case tv = "tv"
    case movie = "movie"
}
