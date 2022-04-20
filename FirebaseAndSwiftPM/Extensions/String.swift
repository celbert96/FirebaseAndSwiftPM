//
//  String.swift
//  BirthdayBotManagerApp
//
//  Created by Christopher Elbert on 1/15/22.
//

import Foundation

extension String {
    func local() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func isEmailAddress() -> Bool {
        //https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
