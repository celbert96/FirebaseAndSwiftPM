//
//  RepositoryResponse.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/25/22.
//

import Foundation

enum RepositoryResponse<T> {
    case success(T? = nil)
    case failed(Error)
    
    static func ==(lhs: RepositoryResponse<T>, rhs: RepositoryResponse<T>) -> Bool {
        switch(lhs, rhs) {
        case (.success(_), .success(_)):
            return true
        case (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }
    
    static func !=(lhs: RepositoryResponse<T>, rhs: RepositoryResponse<T>) -> Bool {
        return !(lhs == rhs)
    }
}
