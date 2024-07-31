//
//  WatchNextApp.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 28/07/24.
//

import SwiftUI

@main
struct WatchNextApp: App {
    @StateObject private var movieListVM = MovieListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieListVM)
        }
    }
}
