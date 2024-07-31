//
//  MovieListViewModel.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 28/07/24.
//

import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isShowForm = false
    @Published var formType = FormType.add
    
    @Published var movieId = 0
    @Published var titleField = ""
    @Published var imageURLField = ""
    @Published var overviewField = ""
    @Published var ratingField: Float = 0
    @Published var isWatchedField = false
    
    @Published var searchText = ""
    @Published var msgInformation = ""
    @Published var showAlertInformation = false
    
    @Published var isLoading = false
    @Published var error: Error? = nil
    
    var movieService = MovieAPIService.shared
    
    func fetchMovies(search: String = "") async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            let movies = try await movieService.fetchWishlistMovies(search: search)
            let unWatchedMovies = movies.filter { $0.isWatched == false }
            let watchedMovies = movies.filter { $0.isWatched == true }
            DispatchQueue.main.async {
                self.movies = []
                self.movies += unWatchedMovies
                self.movies += watchedMovies
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
                self.isLoading = false
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func showAddForm() {
        titleField = ""
        imageURLField = ""
        overviewField = ""
        ratingField = 0
        isWatchedField = false
        
        formType = FormType.add
        isShowForm = true
    }
    
    func showEditForm(movie: Movie) {
        movieId = movie.id
        titleField = movie.title
        imageURLField = movie.imageURL
        overviewField = movie.overview
        ratingField = movie.rating
        isWatchedField = movie.isWatched
        
        formType = FormType.edit
        isShowForm = true
    }
    
    func formValidation() throws {
        if titleField.isEmpty {
            throw FormError.titleError
        }
        if imageURLField.isEmpty {
            throw FormError.imageURLError
        }
        if overviewField.isEmpty {
            throw FormError.overviewError
        }
    }
    
    func addMovie() async {
        do {
            try formValidation()
            let newMovie = MovieAddBodyAPI(title: titleField, overview: overviewField, imageURL: imageURLField, rating: ratingField, isWatched: isWatchedField)
            let movie = try await movieService.addWishlistMovie(newMovie)
            await fetchMovies()
            
            DispatchQueue.main.async {
                self.isShowForm = false
                self.msgInformation = movie.message
                self.showAlertInformation = true
            }
        } catch let error as FormError {
            DispatchQueue.main.async {
                self.showAlertInformation = true
                self.msgInformation = error.description
            }
            print("Error: \(error.description)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func editMovie() async {
        do {
            try formValidation()
            let message = try await movieService.editMovie(Movie(id: movieId, title: titleField, overview: overviewField, imageURL: imageURLField, rating: ratingField, isWatched: isWatchedField))
            await fetchMovies()

            DispatchQueue.main.async {
                self.isShowForm = false
                self.msgInformation = message
                self.showAlertInformation = true
            }
        } catch let error as FormError {
            DispatchQueue.main.async {
                self.msgInformation = error.description
                self.showAlertInformation = true
            }
            print("Error: \(error.description)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteMovie(id: Int) async {
        do {
            let message = try await movieService.deleteMovie(id: id)
            await fetchMovies()
            DispatchQueue.main.async {
                self.msgInformation = message
                self.showAlertInformation = true
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
