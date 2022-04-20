//
//  UIViewController.swift
//  BirthdayBotManagerApp
//
//  Created by Christopher Elbert on 1/15/22.
//

import UIKit
import os.log
extension UIViewController {
    
    /**
        Hide the border for the navigation bar
     
        - Important
            The border will not reappear unless `addNavigationBarBorder` is called
     */
    func hideNavigationBarBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    /**
        Show the navigation bar border
            
        - Important
            This function should only be called if `hideNavigationBar` was called already
     */
    func showNavigationBarBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func initializeKeyboardHandlers(hideKeyboardOnTapAround: Bool = true, adjustViewOnKeyboardNotification: Bool = true) {
        if hideKeyboardOnTapAround {
            self.hideKeyboardOnTapAround()
        }
        if adjustViewOnKeyboardNotification {
            self.adjustViewOnKeyboardNotification()
        }
    }
    
    func adjustViewOnKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2.25
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    /**
        Hide the keyboard when the user taps somewhere outside the editing area
     
        - Important
            Call this function in viewDidLoad
     
     */
    func hideKeyboardOnTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
   
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


