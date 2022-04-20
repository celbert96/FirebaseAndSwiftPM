//
//  UserRepository.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/25/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import os.log
import UIKit

enum UserRepositoryErrors: Error {
    case notImplemented
    case permissionDenied(String?)
    case badRequest(String?)
    case networkCommunicationFailed
    case unknownError
}

class UserRepository: IUserRepository {
    private let logger = Logger(subsystem: "com.celbert.FirebaseAndSwiftPM", category: "UserRepository")
    
    func addUser(user: User, photo: UIImage? = nil) async -> RepositoryResponse<User> {
        if AppStateManager.shared.isUserAuthenticated() {
            logger.error("Could not add user: Logged in user can't create a new user")
            return .failed(UserRepositoryErrors.permissionDenied("Logged in user can't create a new user"))
        }
        
        let userValidationResult = user.validate()
        if userValidationResult != .validInput {
            logger.error("User data is invalid")
            return .failed(UserRepositoryErrors.badRequest("User data is invalid: \(userValidationResult)"))
        }
                
        // Create the user in Firebase Auth
        do {
            try await Auth.auth().createUser(withEmail: user.email, password: user.password)
            // return .success()
        } catch {
            logger.error("Could not add user: \(error.localizedDescription)")
            return .failed(error)
        }
        
        // Verify user created in Firebase
        guard let fbUser = Auth.auth().currentUser else {
            let err = UserRepositoryErrors.unknownError
            logger.error("No current user")
            return .failed(err)
        }
        user.uid = fbUser.uid
        
        // Upload profile pic to Firebase Storage
        if let photo = photo {
            guard let photoURL = await storeProfilePicture(uid: fbUser.uid, photo: photo) else {
                return .failed(UserRepositoryErrors.networkCommunicationFailed)
            }
            
            user.photoURL = photoURL
        }
        
        // Add user object in Firebase Database
        do {
            let dbRef = Database.database().reference()
            try await dbRef.child("users").child(fbUser.uid).setValue(user.asDictionary())
            return .success()
        } catch {
            logger.error("Failed to add user: \(error.localizedDescription)")
            return .failed(error)
        }
        
    }
    
    func updateUser(uid: String, user: User) async -> RepositoryResponse<User> {
        return .failed(UserRepositoryErrors.notImplemented)
    }
    
    func deleteUser(uid: String) async -> RepositoryResponse<User> {
        return .failed(UserRepositoryErrors.notImplemented)
    }
    
    private func storeProfilePicture(uid: String, photo: UIImage) async -> String? {
        guard let data = photo.pngData() else {
            logger.error("Failed to convert image to data")
            return nil
        }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let filename = "\(uid).png"
        let storagePath = "/images/profile_pictures/\(filename)"
        let picRef = storageRef.child(storagePath)
        
        do {
            let metadata = try await picRef.putDataAsync(data)
            logger.log("Uploaded image of size \(metadata.size): ")
        }
        catch {
            logger.error("Could not upload image: \(error.localizedDescription)")
            return nil
        }
        
        
        return storagePath
    }
    
    
}
