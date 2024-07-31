//
//  Form.swift
//  WatchNext
//
//  Created by Fauzan Dwi Prasetyo on 31/07/24.
//

import Foundation

enum FormType {
    case add
    case edit
}

enum FormError: Error {
    case titleError
    case imageURLError
    case overviewError
    
    var description: String {
        switch self {
        case .titleError:
            return "Title is required"
        case .imageURLError:
            return "Image URL is required"
        case .overviewError:
            return "Overview is required"
        }
    }
}
