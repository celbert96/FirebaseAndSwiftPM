//
//  UIResponder.swift
//  BirthdayBotManagerApp
//
//  Created by Christopher Elbert on 1/15/22.
//

import UIKit

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public static var current: UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}
