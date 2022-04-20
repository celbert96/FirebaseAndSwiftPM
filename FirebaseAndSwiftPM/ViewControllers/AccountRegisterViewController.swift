//
//  AccountRegisterViewController.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/27/22.
//

import UIKit

class AccountRegisterViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    let KEYBOARD_FRAME_OFFSET = CGFloat(10.0)
    let TEXTFIELD_MIN_TOP_MARGIN = CGFloat(20.0)
    
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDelegates()
        addKeyboardHandlers()
        setupUI()
    }
    
    private func setTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func addKeyboardHandlers() {
        initializeKeyboardHandlers(hideKeyboardOnTapAround: true, adjustViewOnKeyboardNotification: false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = false
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
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
    
    /**
     Adjust scrollView's contentOffset to fit the keyboard
     
    - Important: To ensure that the active textfield does not go off the screen, make sure to assign all textfields' delegates to self
     */
    private func adjustScrollViewOffsetForKeyboard(keyboardFrame: CGRect) {
        // Calculate offset needed for keyboard
        let distanceFromBtnToViewBottom = contentView.frame.size.height - (continueButton.frame.size.height + continueButton.frame.origin.y)
        var scrollViewYOffset = keyboardFrame.size.height - distanceFromBtnToViewBottom + KEYBOARD_FRAME_OFFSET
        
        // Make sure there is adequate space above text field
        if let activeTextField = activeTextField {
            if activeTextField.frame.origin.y - (scrollViewYOffset + TEXTFIELD_MIN_TOP_MARGIN) < 0 {
                // Do not adjust the content offset if doing so will push the textfield off the screen
                scrollViewYOffset = 0
            }
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: true)
    }
    
    private func transitionToProfileSetupViewController(user: User) {
        guard let profileSetupVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSetupVC") as? ProfileSetupViewController else {
            return
        }
        
        profileSetupVC.user = user
        self.navigationController?.pushViewController(profileSetupVC, animated: true)
    }
    
    @objc private func continueButtonClicked(_ sender: UIButton) {
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
        
        guard let confirmPassword = confirmPasswordTextField.text else {
            let err = FormValidationResult.missingField("Email")
            showAlert(title: "Validation Error", message: err.description)
            return
        }
        
        if password != confirmPassword {
            let err = FormValidationResult.passwordsDontMatch
            showAlert(title: "Validation Error", message: err.description)
            return
        }
        
        let user = User(email: email, password: password)
        let validationResult = user.validate()
        
        // Ignore invalid password error on login (in case password requirements are updated)
        if validationResult != .validInput {
            showAlert(title: "Validation Error", message: validationResult.description)
        } else {
            transitionToProfileSetupViewController(user: user)
        }
    }
}

extension AccountRegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
