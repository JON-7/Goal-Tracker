//
//  CreateGoal+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 3/29/21.
//

import UIKit

extension CreateGoalVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        DispatchQueue.main.async {
            if self.gainButton.isSelected {
                self.gainButton.backgroundColor = self.color
            } else if self.loseButton.isSelected {
                self.loseButton.backgroundColor = self.color
            }
        }
    }
    
    // Check to see if all necessary textfields contain information
    // If not an alert will be shown telling them what fields they need to complete
    func isAllDataValid() -> Bool {
        let goalName = goalTextfield.text ?? ""
        let startNumText = currentNumberTF.text
        let endNumText = numberTextfield.text
        var checksPassed = 0
        
        if goalName == "" {
            displayFormErrorMessage(errorType: FormErrorType.emptyNameField)
        } else { checksPassed += 1 }
        
        if startNumText == "" && endNumText != "" {
            displayFormErrorMessage(errorType: FormErrorType.missingStartNumber)
        } else { checksPassed += 1 }
        
        if startNumText != "" && endNumText == "" {
            displayFormErrorMessage(errorType: FormErrorType.missingEndNumber)
        } else { checksPassed += 1 }
        
        if checksPassed == 3 {
            return true
        } else { return false }
    }
    
    func createDatePicker() {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 75))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        
        let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        let makeSpaceBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let removeBtn = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeDate))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dismissWithDone))
        toolbar.setItems([removeBtn, makeSpaceBtn, doneBtn], animated: true)
        
        dateTextfield.inputAccessoryView = toolbar
        dateTextfield.inputView = datePicker
    }
    
    @objc func removeDate() {
        DispatchQueue.main.async {
            self.dateTextfield.text = ""
        }
    }
    
    func configureDone() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let makeSpaceBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                     action: #selector(dismissWithDone))
        toolBar.setItems([makeSpaceBtn, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func dismissWithDone() {
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        self.dateTextfield.text = dateFormat.string(from: datePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalTextfield.resignFirstResponder()
        dateTextfield.resignFirstResponder()
        return true
    }
}
