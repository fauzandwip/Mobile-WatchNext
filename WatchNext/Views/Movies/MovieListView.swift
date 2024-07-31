//
//  MovieListView.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 28/07/24.
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject private var movieListVM: MovieListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let error = movieListVM.error {
                    ErrorView(error: error) {
                        Task {
                            await movieListVM.fetchMovies()
                        }
                    }
                } else if movieListVM.isLoading {
                    ProgressView()
                } else {
                    List(movieListVM.movies) { movie in
                        ZStack {
                                MovieCardView(movie: movie)
                                    .environmentObject(MovieDetailViewModel(movie: movie, movieListVM: movieListVM))
                                NavigationLink {
                                    MovieDetailView(movie: movie)
                                        .environmentObject(MovieDetailViewModel(movie: movie, movieListVM: movieListVM))
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .sheet(isPresented: $movieListVM.isShowForm) {
                            MovieFormView()
                                .environmentObject(MovieDetailViewModel(movie: movie, movieListVM: movieListVM))
                        }
                        
                    }
                    .listStyle(.plain)
                    .alert(movieListVM.msgInformation, isPresented: $movieListVM.showAlertInformation) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
            .task {
                await movieListVM.fetchMovies()
            }
            .navigationTitle("WatchNext Movies")
            .searchable(text: $movieListVM.searchText, placement: .navigationBarDrawer(displayMode: .always),prompt: Text("search product"))
            .onChange(of: movieListVM.searchText) { value in
                Task {
                    await movieListVM.fetchMovies(search: value)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        movieListVM.showAddForm()
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(.blue.opacity(0.6))
                            .cornerRadius(.infinity)
                    }
                }
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
            .environmentObject(MovieListViewModel())
    }
}
