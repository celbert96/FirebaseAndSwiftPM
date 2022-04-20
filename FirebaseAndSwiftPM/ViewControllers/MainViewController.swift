//
//  MainViewController.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 4/4/22.
//

import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
