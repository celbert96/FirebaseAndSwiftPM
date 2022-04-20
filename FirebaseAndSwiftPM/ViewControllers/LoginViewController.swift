//
//  LoginViewController.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/24/22.
//

import UIKit
import os.log

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private let KEYBOARD_FRAME_OFFSET = CGFloat(10.0)
    
    private var logger = Logger.init(subsystem: "com.celbert.FirebaseAndSwiftPM", category: "LoginViewController")
    
    
    override func viewWillAppear(_ animated: Bool) {
        if AppStateManager.shared.isUserAuthenticated() {
            logger.log("User is logged in!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeKeyboardHandlers(hideKeyboardOnTapAround: true, adjustViewOnKeyboardNotification: false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    // MARK: Keyboard Handlers
    @objc override func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            adjustScrollViewOffsetForKeyboard(keyboardFrame: keyboardFrame)
        }
    }
    
    private func adjustScrollViewOffsetForKeyboard(keyboardFrame: CGRect) {
        let distanceFromLoginBtnToViewBottom = contentView.frame.size.height - (loginButton.frame.size.height + loginButton.frame.origin.y)
        let scrollViewYOffset = keyboardFrame.size.height - distanceFromLoginBtnToViewBottom + KEYBOARD_FRAME_OFFSET
        
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: true)
    }
    
    @objc private func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            let err = FormValidationResult.missingField("Email")
            showAlert(title: "Validation Error", message: err.description)
            return
        }
        
        guard let password = passwordTextField.text else {
            let err = FormValidationResult.missingField("Password")
            showAlert(title: "Validation Error", message: err.description)
            return
        }
        
        let user = User(email: email, password: password)
        let validationResult = user.validate()
        
        // Ignore invalid password error on login (in case password requirements are updated)
        if validationResult != .validInput && validationResult != .invalidPasswordFormat {
            showAlert(title: "Validation Error", message: validationResult.description)
        } else {
            SpinnerUtility.shared.displaySpinnerOverViewController(spinnerText: "Signing in...", viewController: self)
            Task {
                let userService = UserService(userRepository: UserRepository())
                let signInResult = await userService.signInUser(email: email, password: password)
                switch signInResult {
                case .success(_):
                    let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
                    self.navigationController?.setViewControllers([homeViewController], animated: true)
                case .failed(let err):
                    showAlert(title: "Failed", message: err.localizedDescription)
                }
                
                SpinnerUtility.shared.dismissSpinner()
            }
        }
    }
}
