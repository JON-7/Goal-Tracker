//
//  UIViewController+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

extension UIViewController: UITextFieldDelegate, UIColorPickerViewControllerDelegate {
    
    func dismissKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func convertStringToDate(stringDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, 00:00:00"
        let date = formatter.date(from: stringDate) ?? Date()
        return date
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        let formatedDate = dateFormatter.string(from: date)
        return formatedDate
    }
}
