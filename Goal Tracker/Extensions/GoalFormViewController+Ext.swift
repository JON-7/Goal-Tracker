//
//  GoalFormViewController+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

extension GoalFormViewController {
    
    func createDatePicker() {
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: goalNameField.bottomAnchor, constant: topPadding),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.25 + sidePadding + 10),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.bounds.width * 0.3)),
            datePicker.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier)
        ])
        
        if goalAction == .create {
            datePicker.isHidden = true
            removeDateButton.isHidden = true
        }
    
        datePicker.tintColor = color
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date().localDate().tomorrow()
        
        dateFieldButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        removeDateButton.addTarget(self, action: #selector(removeDate), for: .touchUpInside)
    }
    
    @objc private func showDatePicker() {
        datePicker.isHidden = false
        removeDateButton.isHidden = false
    }
    
    @objc func removeDate() {
        removeDateButton.isHidden = true
        datePicker.isHidden = true
        datePicker.date = Date().tomorrow()
    }
    
    @objc func dateChanged() {
        removeDateButton.isHidden = false
        self.date = datePicker.date
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalDateField.goalTF.resignFirstResponder()
        goalDateField.goalTF.resignFirstResponder()
        return true
    }
    
    func isAllDataValid() -> Bool {
        let goalName = goalNameField.goalTF.text ?? ""
        let startNumText = currentNumberField.goalTF.text
        let endNumText = goalNumberField.goalTF.text
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
        date = .none
    }
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
    
    func tomorrow() -> Date {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date().localDate()) ?? Date()
        return tomorrow
    }
}

