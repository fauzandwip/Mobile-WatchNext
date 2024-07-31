//
//  MovieDetailViewModel.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 30/07/24.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var isWatched = false
    @Published var showDeleteConfirmation = false
    
    private let movieListVM: MovieListViewModel
    private var movieAPIService = MovieAPIService()
    
    init(movie: Movie, movieListVM: MovieListViewModel) {
        self.movie = movie
        self.movieListVM = movieListVM
        self.isWatched = movie.isWatched
    }
    
    func updateIsWatchedStatus() {
        self.isWatched.toggle()
        
        Task {
            do {
                let _ = try await movieAPIService.updateIsWatchedStatus(id: movie.id, isWatched: UpdateStatusBodyAPI(isWatched: isWatched))
                await movieListVM.fetchMovies()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteMovie() {
        showDeleteConfirmation = false
        Task {
            await movieListVM.deleteMovie(id: movie.id)
        }
    }
}
