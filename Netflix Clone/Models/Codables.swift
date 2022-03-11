//
//  Codable.swift
//  Netflix Clone
//
//  Created by Manu on 11/03/2022.
//

import Foundation
// let movies = try? newJSONDecoder().decode(Movies.self, from: jsonData)
// MARK: - Movies
struct TrendingMoviesResponse: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let overview: String
    let releaseDate: String?
    let adult: Bool?
    let backdropPath: String
    let genreIDS: [Int]
    let voteCount: Int
    let originalLanguage: OriginalLanguage
    let originalTitle: String?
    let posterPath: String
    let video: Bool?
    let id: Int
    let voteAverage: Double
    let title: String?
    let popularity: Double
    let mediaType: MediaType
    let firstAirDate, name, originalName: String?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case overview
        case releaseDate = "release_date"
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case video, id
        case voteAverage = "vote_average"
        case title, popularity
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case name
        case originalName = "original_name"
        case originCountry = "origin_country"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginalLanguage: String, Codable {
    case da = "da"
    case en = "en"
    case pl = "pl"
}
