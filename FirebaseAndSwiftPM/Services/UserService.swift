//
//  UserService.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/27/22.
//

import Foundation
import FirebaseAuth
import os.log
import UIKit

class UserService {
    private let logger = Logger(subsystem: "com.celbert.FirebaseAndSwiftPM", category: "UserService")
    private var userRepository: IUserRepository
    
    init(userRepository: IUserRepository) {
        self.userRepository = userRepository
    }
    
    func signInUser(email: String, password: String) async -> RepositoryResponse<Any> {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return .success()
        } catch {
            logger.error("Error: \(error.localizedDescription)")
            return .failed(error)
        }
    }
    
    func addUser(user: User, photo: UIImage?) async -> RepositoryResponse<User> {
        return await userRepository.addUser(user: user, photo: photo)
    }
}
