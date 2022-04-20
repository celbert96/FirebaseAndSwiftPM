//
//  User.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/24/22.
//

import Foundation

class User: Model {
    var uid: String?
    var email: String
    var password: String
    var photoURL: String?
    var nickname: String?
    var isPremium: Bool
    
    public init(email: String, password: String, photoURL: String? = nil, nickname: String? = nil, isPremium: Bool = false) {
        self.email = email
        self.password = password
        self.photoURL = photoURL
        self.nickname = nickname
        self.isPremium = isPremium
    }
    
    public func validate() -> FormValidationResult {
        guard !email.isEmpty else {
            return .missingField("Email")
        }
        
        guard !password.isEmpty else {
            return .missingField("Password")
        }
        
        if !email.isEmailAddress() {
            return .invalidEmailFormat
        }
        
        if password.count <= 5 {
            return .invalidPasswordFormat
        }
        
        return .validInput
    }
    
    public func asDictionary(passwordRedacted: Bool = true) -> Dictionary<String, Any?> {
        if passwordRedacted {
            return [
                "uid": uid,
                "email": email,
                "photoURL": photoURL,
                "nickname": nickname,
                "isPremium": isPremium
            ]
        }
        
        return [
            "uid": uid,
            "email": email,
            "password": password,
            "photoURL": photoURL,
            "nickname": nickname,
            "isPremium": isPremium
        ]
    }
}
