//
//  MovieDetailView.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 31/07/24.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject private var movieDetailVM: MovieDetailViewModel
    var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                imageMovie
                
                VStack {
                    VStack {
                        detailMovie
                        
                        overview
                    }
                }
                .padding(20)
                .background(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension MovieDetailView {
    private var imageMovie: some View {
        AsyncImage(url: URL(string: movie.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                ProgressView()
                    .frame(height: 600)
                    .frame(maxWidth: .infinity)
            }
    }
    
    private var detailMovie: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                // title
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // rating
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(String(format: "%.1f", movie.rating))")
                        .fontWeight(.medium)
                }
                .font(.title3)
                .fontWeight(.bold)
            }
            Spacer()
            Spacer()
                .frame(width: 10)
            
            // isWatched
            Image(systemName: movie.isWatched ? "eye.slash.fill" : "eye.fill")
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
    
    private var overview: some View {
        Text(movie.overview)
        .padding(5)
        .padding(.top)
    }
}

//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailView()
//    }
//}
