//
//  MovieFormView.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 29/07/24.
//

import SwiftUI

struct MovieFormView: View {
    @EnvironmentObject private var movieListVM: MovieListViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            Text(movieListVM.formType == .add ? "Add Movie to Wishlist" : "Edit Movie")
                .font(.title)
                .fontWeight(.bold)

            titleField
            
            imageURLField
            
            overviewField
            
            ratingField
        
            isWatchedField
            
            Spacer()
            
            submitButton

        }
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
        .alert(movieListVM.msgInformation, isPresented: $movieListVM.showAlertInformation) {
            Button("OK", role: .cancel) {}
        }
    }
}

extension MovieFormView {
    private var titleField: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.title3)
                .fontWeight(.medium)
            TextField("movie title", text: $movieListVM.titleField)
                .padding()
                .background(.mint.opacity(0.2))
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.mint, lineWidth: 2)
                }
        }
    }
    
    private var imageURLField: some View {
        VStack(alignment: .leading) {
            Text("Image URL")
                .font(.title3)
                .fontWeight(.medium)
            TextField("movie image URL", text: $movieListVM.imageURLField)
                .padding()
                .background(.mint.opacity(0.2))
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.mint, lineWidth: 2)
                }
        }
    }
    
    private var overviewField: some View {
        VStack(alignment: .leading) {
            Text("Overview")
                .font(.title3)
                .fontWeight(.medium)
            TextEditor(text: $movieListVM.overviewField)
                .padding()
                .scrollContentBackground(.hidden)
                .background(.mint.opacity(0.2))
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.mint, lineWidth: 2)
                }
                .frame(height: 150)
        }
    }
    
    private var ratingField: some View {
        Stepper("Rating: \(String(format: "%.0f", movieListVM.ratingField))", value: $movieListVM.ratingField, in: 0...10)
            .font(.title3)
            .fontWeight(.medium)
    }
    
    private var isWatchedField: some View {
        Toggle("Is Watched?", isOn: $movieListVM.isWatchedField)
            .font(.title3)
            .fontWeight(.medium)
    }
    
    private var submitButton: some View {
        HStack {
            Spacer()
            Button {
                Task {
                    if movieListVM.formType == .add {
                        await movieListVM.addMovie()
                    } else if movieListVM.formType == .edit {
                        await movieListVM.editMovie()
                    }
                }
            } label: {
                Text(movieListVM.formType == .add ? "Add Movie" : "Edit Movie")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        .background(.blue)
                        .cornerRadius(15)
            }
        }
    }
}

//struct MovieFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieFormView()
//            .environmentObject(MovieListViewModel())
//    }
//}
