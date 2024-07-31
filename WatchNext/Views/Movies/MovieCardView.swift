//
//  MovieCardView.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 29/07/24.
//

import SwiftUI

struct MovieCardView: View {
    @EnvironmentObject private var movieListVM: MovieListViewModel
    @EnvironmentObject private var movieDetailVM: MovieDetailViewModel
    var movie: Movie
    
    var body: some View {
        HStack {
            imageMovie
            
            VStack(alignment: .leading) {
                infoMovie
                
                Spacer()
                
               actionButtons
            }
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 15))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(.thinMaterial)
        .cornerRadius(15)
        .grayscale(movieDetailVM.isWatched ? 1.0 : 0.0)
        .blur(radius: movieDetailVM.isWatched ? 0.5 : 0.0)
    }
}

extension MovieCardView {
    private var infoMovie: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                // rating
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(String(format: "%.1f",movie.rating))")
                        .fontWeight(.medium)
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            Image(systemName: movieDetailVM.isWatched ? "eye.slash.fill" : "eye.fill")
                .padding(6)
                .foregroundColor(movieDetailVM.isWatched ? .white : .black)
                .background(movieDetailVM.isWatched ? .black : .clear)
                .cornerRadius(.infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(.black)
                }
                .onTapGesture {
                    movieDetailVM.updateIsWatchedStatus()
                }
        }
    }
    
    private var imageMovie: some View {
        AsyncImage(url: URL(string: movie.imageURL)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
                .frame(maxWidth: 135)
        }
    }
    
    private var actionButtons: some View {
        HStack {
            Spacer()
            
            // edit button
            Image(systemName: "square.and.pencil")
                .padding(8)
                .background(.green.opacity(0.8))
                .cornerRadius(10)
                .onTapGesture {
                    movieListVM.showEditForm(movie: movie)
                }
            
            // delete button
            Image(systemName: "trash")
                .padding(8)
                .background(.red.opacity(0.8))
                .cornerRadius(10)
                .onTapGesture {
                    movieDetailVM.showDeleteConfirmation = true
                }
                .alert("Delete Movie", isPresented: $movieDetailVM.showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        movieDetailVM.deleteMovie()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure to delete movie from Wishlist?")
                }
            
        }
        .font(.title3)
        .foregroundColor(.white)
    }
}

//struct MovieCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieCardView()
//    }
//}
