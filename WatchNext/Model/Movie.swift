//
//  Movie.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 28/07/24.
//

import Foundation

struct GetMoviesResponseAPI: Decodable {
    var message: String
    var data: [Movie]
}

struct MovieAddResponseAPI: Decodable {
    var message: String
    var data: Movie
}

struct MessageResponseAPI: Decodable {
    var message: String
}

struct UpdateStatusBodyAPI: Encodable {
    var isWatched: Bool
}

struct MovieAddBodyAPI: Encodable {
    var title: String
    var overview: String
    var imageURL: String
    var rating: Float
    var isWatched: Bool
}

struct Movie: Codable, Identifiable {
    var id: Int
    var title: String
    var overview: String
    var imageURL: String
    var rating: Float
    var isWatched: Bool
}
