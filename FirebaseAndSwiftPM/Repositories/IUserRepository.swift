//
//  IUserRepository.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/25/22.
//

import Foundation
import UIKit

protocol IUserRepository {
    func addUser(user: User, photo: UIImage?) async -> RepositoryResponse<User>
    func updateUser(uid: String, user: User) async -> RepositoryResponse<User>
    func deleteUser(uid: String) async -> RepositoryResponse<User>
}
