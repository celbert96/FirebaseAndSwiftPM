//
//  SpinnerView.swift
//  BirthdayBotManagerApp
//
//  Created by Christopher Elbert on 1/17/22.
//

import UIKit

class SpinnerView: UIView {
    public static let XIB_NAME = "SpinnerView"
    
    @IBOutlet weak var spinnerLabel: UILabel!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = self.loadViewFromNib(nibName: SpinnerView.XIB_NAME) else {
            return
        }
        
        view.frame = self.bounds
        self.addSubview(view)

    }
}
