//
//  ErrorView.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 31/07/24.
//

import SwiftUI

struct ErrorView: View {
    var error: Error
    var reload: () async -> Void
    
    var body: some View {
        Text("\(error.localizedDescription)")
        Button {
            Task {
                await reload()
            }
        } label: {
            Text("Reload")
                .padding(10)
                .foregroundColor(.white)
                .background(.teal)
                .cornerRadius(10)
        }
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
