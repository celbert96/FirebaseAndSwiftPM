//
//  Model.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/24/22.
//

import Foundation

protocol Model: Codable {
    func validate() -> FormValidationResult
}
