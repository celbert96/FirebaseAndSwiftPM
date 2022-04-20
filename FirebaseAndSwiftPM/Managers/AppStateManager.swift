//
//  AppStateManager.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/25/22.
//

import Foundation
import FirebaseAuth
import os.log

class AppStateManager {
    static let shared = AppStateManager()
    private let lockQueue = DispatchQueue(label: "AppStateManager.lockQueue", qos: .default, attributes: .concurrent)
    private var logger = Logger.init(subsystem: "com.celbert.FirebaseAndSwiftPM", category: "AppStateManager")
    
    private var authStateChangedHandler: AuthStateDidChangeListenerHandle? = nil
    private var userAuthenticated = false
    
    
    private init() {
        // TODO: This is for testing. Remove later
        logoutUser()
        
        
        startAuthListener()
    }
    
    
    deinit {
        if let authStateChangedHandler = authStateChangedHandler {
            Auth.auth().removeStateDidChangeListener(authStateChangedHandler)
        }
    }
    
    
    func startAuthListener() {
        authStateChangedHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.logger.debug("Auth state changed")
            
            if let user = user {
                strongSelf.logger.debug("User is authenticated > uid: \(user.uid)")
                strongSelf.userAuthenticated = true
            } else {
                strongSelf.logger.debug("User is not authenticated")
                strongSelf.userAuthenticated = false
            }
        }
    }
    
    func isUserAuthenticated() -> Bool {
        lockQueue.sync {
            return userAuthenticated
        }
    }
    
    // TODO: This is only here for testing. Remove later
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            logger.error("Error: \(error.localizedDescription)")
        }
        
    }
}
