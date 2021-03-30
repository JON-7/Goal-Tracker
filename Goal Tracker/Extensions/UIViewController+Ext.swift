//
//  UIViewController+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 3/29/21.
//

import UIKit

extension UIViewController: UITextFieldDelegate, UINavigationControllerDelegate {
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func displayFormErrorMessage(errorType: FormErrorType) {
        var ac = UIAlertController()
        switch errorType {
        case .emptyNameField:
            ac = UIAlertController(title: "Please Enter a Goal Name", message: "", preferredStyle: .alert)
        case .missingStartNumber:
            ac = UIAlertController(title: "Enter Starting Number", message: "Please enter a starting number or remove the ending number", preferredStyle: .alert)
        case .missingEndNumber:
            ac = UIAlertController(title: "Enter Final Number Goal", message: "Please enter your final numeric goal or remove the starting number", preferredStyle: .alert)
        }
        
        let action = UIAlertAction(title: "Continue", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func dismissKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}
