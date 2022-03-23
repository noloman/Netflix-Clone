//
//  APICalled.swift
//  Netflix Clone
//
//  Created by Manu on 11/03/2022.
//

import UIKit

struct Constants {
    static let API_KEY = "06cd3aafde48e70efdd2eb19807195c4"
    static let baseURL = "https://api.themoviedb.org"
    static let YOUTUBE_API_KEY = "AIzaSyDLSqxs063N_Fn1DIGsYLFXwfoFqrIQt-4"
    static let YOUTUBE_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies() async throws -> TrendingMoviesResponse? {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movies/day?api_key=\(Constants.API_KEY)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
    }
    
    func getTrendingShows() async throws -> TrendingShowsResponse? {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
    }
    
    func getUpcomingMovies() async throws -> TrendingMoviesResponse? {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
    }
    
    func getPopularMovies() async throws -> TrendingMoviesResponse? {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
    }
    
    func getTopRatedMovies() async throws -> TrendingMoviesResponse? {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
    }
    
    func getDiscoverMovies() async throws -> TrendingMoviesResponse? {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
    }
    
    func search(_ query: String) async throws -> TrendingMoviesResponse? {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
    }
    
    func getMovie(with query: String) async throws -> YoutubeSearchResponse? {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        guard let url = URL(string: "\(Constants.YOUTUBE_BASE_URL)q=\(query)&key=\(Constants.YOUTUBE_API_KEY)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
    }
}
