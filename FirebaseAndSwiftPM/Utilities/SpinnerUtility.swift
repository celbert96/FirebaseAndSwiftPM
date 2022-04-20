//
//  SpinnerUtility.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 4/20/22.
//

import UIKit
import os.log

@MainActor class SpinnerUtility {
    public static let shared = SpinnerUtility()
    private var spinnerView: SpinnerView?
    private var callingViewController: UIViewController?
    
    private var logger = Logger.init(subsystem: "com.celbert.FirebaseAndSwiftPM", category: "SpinnerUtility")
    
    public func displaySpinnerOverViewController(spinnerText: String, viewController: UIViewController) {
        guard spinnerView == nil, callingViewController == nil else {
            // error - spinner already displayed
            logger.error("displaySpinnerOverViewController but spinner was already being displayed")
            return
        }
        
        spinnerView = SpinnerView()
        callingViewController = viewController
        guard let unwrappedSpinnerView = spinnerView else {
            logger.error("Could not unwrap spinnerView")
            return
        }
        
        viewController.navigationController?.isNavigationBarHidden = true
        
        unwrappedSpinnerView.spinnerLabel.text = spinnerText
        unwrappedSpinnerView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(unwrappedSpinnerView)
        NSLayoutConstraint.activate([
            unwrappedSpinnerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            unwrappedSpinnerView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            unwrappedSpinnerView.heightAnchor.constraint(equalTo: viewController.view.heightAnchor),
            unwrappedSpinnerView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor)
        ])
        
        logger.info("Spinner is being displayed")
    }
    
    public func displaySpinnerOverView(spinnerText: String, view: UIView, viewController: UIViewController) {
        guard spinnerView == nil, callingViewController == nil else {
            // error - spinner already displayed
            logger.error("displaySpinnerOverView but spinner was already being displayed")
            return
        }
        
        spinnerView = SpinnerView()
        callingViewController = viewController
        guard let unwrappedSpinnerView = spinnerView else {
            return
        }
                
        unwrappedSpinnerView.spinnerLabel.text = spinnerText
        unwrappedSpinnerView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(unwrappedSpinnerView)
        NSLayoutConstraint.activate([
            unwrappedSpinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unwrappedSpinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            unwrappedSpinnerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            unwrappedSpinnerView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        logger.info("Spinner is being displayed")
    }
    
    public func dismissSpinner() {
        guard let unwrappedSpinnerView = spinnerView, let unwrappedViewController = callingViewController else {
            return
        }
        
        unwrappedViewController.navigationController?.isNavigationBarHidden = false
        unwrappedSpinnerView.removeFromSuperview()
        logger.info("Spinner has been dismissed")
        
        spinnerView = nil
        callingViewController = nil
    }
}

