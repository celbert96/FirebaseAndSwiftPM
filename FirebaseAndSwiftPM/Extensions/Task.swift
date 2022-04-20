//
//  Task.swift
//  BirthdayBotManagerApp
//
//  Created by Christopher Elbert on 1/17/22.
//

import Foundation

//https://stackoverflow.com/questions/68715266/how-to-await-x-seconds-with-async-await-swift-5-5
extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
