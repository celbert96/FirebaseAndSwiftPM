//
//  FormValidationResult.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/24/22.
//

import Foundation

enum FormValidationResult {
    case validInput
    case missingField(String)
    case invalidEmailFormat
    case invalidPasswordFormat
    case passwordsDontMatch
    
    var description: String {
        switch(self) {
        case .validInput:
            return "Valid input"
        case .missingField(let fieldName):
            return "Required field \(fieldName) is empty"
        case .invalidEmailFormat:
            return "Email is not valid"
        case .invalidPasswordFormat:
            return "Password does not meet requirements"
        case .passwordsDontMatch:
            return "Passwords don't match"
        }
    }
    
    static func ==(lhs: FormValidationResult, rhs: FormValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (let .missingField(a1), let .missingField(a2)):
            return a1 == a2
        case (.validInput, .validInput):
            return true
        case (.invalidEmailFormat, .invalidEmailFormat):
            return true
        case (.invalidPasswordFormat, .invalidPasswordFormat):
            return true
        case (.passwordsDontMatch, .passwordsDontMatch):
            return true
        default:
            return false
        }
    }
    
    static func !=(lhs: FormValidationResult, rhs: FormValidationResult) -> Bool {
        return !(lhs == rhs)
    }
}
