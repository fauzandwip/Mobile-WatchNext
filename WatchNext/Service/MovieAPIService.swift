//
//  MovieService.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 28/07/24.
//

import Foundation

struct APIBasePath {
    static let BASE_PATH = "http://localhost:3000"
}

struct APIEndpoint {
    static let movies = APIBasePath.BASE_PATH + "/movies"
}

class MovieAPIService {
    static let shared = MovieAPIService()
    
    func fetchWishlistMovies(search: String = "") async throws -> [Movie] {
        let encodedQuery = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: APIEndpoint.movies + "?search=\(encodedQuery)") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedResponse = try JSONDecoder().decode(GetMoviesResponseAPI.self, from: data)
        return decodedResponse.data
    }
    
    func addWishlistMovie(_ newMovie: MovieAddBodyAPI) async throws -> MovieAddResponseAPI {
        guard let url = URL(string: APIEndpoint.movies) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(newMovie)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedResponse = try JSONDecoder().decode(MovieAddResponseAPI.self, from: data)

        return decodedResponse
    }
    
    func editMovie(_ movie: Movie) async throws -> String {
        guard let url = URL(string: APIEndpoint.movies + "/\(movie.id)") else {
            throw APIError.invalidURL
        }
        
        let updatedMovie = MovieAddBodyAPI(title: movie.title, overview: movie.overview, imageURL: movie.imageURL, rating: movie.rating, isWatched: movie.isWatched)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(updatedMovie)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedResponse = try JSONDecoder().decode(MessageResponseAPI.self, from: data)
        
        return decodedResponse.message
    }
    
    func deleteMovie(id: Int) async throws -> String {
        guard let url = URL(string: APIEndpoint.movies + "/\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedResponse = try JSONDecoder().decode(MessageResponseAPI.self, from: data)
        
        return decodedResponse.message
    }
    
    func updateIsWatchedStatus(id: Int, isWatched: UpdateStatusBodyAPI) async throws -> String {
        guard let url = URL(string: APIEndpoint.movies + "/\(id)/watch") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(isWatched)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedResponse = try JSONDecoder().decode(MessageResponseAPI.self, from: data)

        return decodedResponse.message
    }
}

enum APIError: Error {
    case invalidURL
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
