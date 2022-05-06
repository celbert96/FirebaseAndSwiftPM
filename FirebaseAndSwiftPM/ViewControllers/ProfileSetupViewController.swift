//
//  ProfileSetupViewController.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 3/27/22.
//

import UIKit
import PhotosUI

class ProfileSetupViewController: UIViewController {
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var selectProfileLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    

    @IBOutlet weak var completeRegistrationButton: UIButton!
    
    let KEYBOARD_FRAME_OFFSET = CGFloat(10.0)
    let TEXTFIELD_MIN_TOP_MARGIN = CGFloat(20.0)
    
    var activeTextField: UITextField?
    
    var user: User? // Must be passed by previous view controller
    
    override func viewDidLoad() {
        // We don't need to adjust the view height for the keyboard because doing so would make the only textfield on this page not visible
        initializeKeyboardHandlers(hideKeyboardOnTapAround: true, adjustViewOnKeyboardNotification: false)
        setupUI()
    }
    
    private func setupUI() {
        editProfilePictureButton.addTarget(self, action: #selector(presentPhotoPicker), for: .touchUpInside)
        completeRegistrationButton.addTarget(self, action: #selector(completeRegistrationButtonPressed), for: .touchUpInside)
    }
    
    @objc private func presentPhotoPicker(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func completeRegistrationButtonPressed(_ sender: UIButton) {
        guard let user = user else {
            showAlert(title: "Internal Error", message: "An internal error occurred. Please try again.")
            return
        }
        
        guard let nickname = displayNameTextField.text else {
            let err = FormValidationResult.missingField("Nickname")
            showAlert(title: "Validation Error", message: err.description)
            return
        }
        
        guard let profilePhoto = profilePictureImageView.image else {
            let err = FormValidationResult.missingField("Profile Picture")
            showAlert(title: "Validation Error", message: err.description)
            return
        }
        
        user.nickname = nickname
        
        Task {
            SpinnerUtility.shared.displaySpinnerOverViewController(spinnerText: "Creating account...", viewController: self)
            let userAddResult = await UserService(userRepository: UserRepository()).addUser(user: user, photo: profilePhoto)
            switch userAddResult {
            case .success(_):
                moveToMainViewController()
            case .failed(let err):
                showAlert(title: "Failed", message: err.localizedDescription)
            }
            
            SpinnerUtility.shared.dismissSpinner()
        }
    }
    
    private func moveToMainViewController() {
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        self.navigationController?.setViewControllers([homeViewController], animated: true)
    }
}

extension ProfileSetupViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = profilePictureImageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage, self.profilePictureImageView.image == previousImage else {
                        return
                    }
                    self.profilePictureImageView.image = image
                }
            }
        }
    }
}
