//
//  AlertViewController.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: Button!
    
    fileprivate var message: String?
    fileprivate var buttonTitle: String?
    
    static func initialize(message: String, buttonTitle: String) -> AlertViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alertController") as? AlertViewController else {
            fatalError("Could not instantiate alert controller")
        }
        
        controller.message = message
        controller.buttonTitle = buttonTitle
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = message
        doneButton.setTitle(buttonTitle, for: .normal)
    }
}
