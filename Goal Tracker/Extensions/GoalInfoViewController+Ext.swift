//
//  GoalInfoViewController+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

extension GoalInfoViewController {
    
    @objc func showUpdateForm() {
        if String(goal.startNum) == "0.0" {
            form.currentNumberField.goalTF.text = ""
        } else {
            form.currentNumberField.goalTF.text = String(goal.startNum.formatToString)
        }
        
        if String(goal.endNum) == "0.0" {
            form.goalNumberField.goalTF.text = ""
        } else {
            form.goalNumberField.goalTF.text = String(goal.endNum.formatToString)
        }
        
        if goal.date == "" {
            form.datePicker.isHidden = true
            form.removeDateButton.isHidden = true
        } else {
            form.datePicker.date = convertStringToDate(stringDate: goal.date ?? "")
        }
        
        form.goalNameField.goalTF.text = goal.name
        form.color = goal.cellColor
        form.isGainGoal = goal.isGainGoal
        form.goalColorButton.backgroundColor = goal.cellColor
        form.createButton.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
        form.deleteButton.addTarget(self, action: #selector(showDeleteWarning), for: .touchUpInside)
        navigationController?.pushViewController(form, animated: true)
    }
    
    @objc private func saveInfo() {
        guard form.isAllDataValid() else { return }
        if let sub = goal as? SubGoal {
            sub.name = form.goalNameField.goalTF.text
            sub.startNum = Double(form.currentNumberField.goalTF.text!) ?? 0
            sub.endNum = Double(form.goalNumberField.goalTF.text!) ?? 0
            sub.cellColor = form.color
            sub.isGainGoal = form.isGainGoal
            
            if form.datePicker.isHidden {
                sub.date = ""
            } else {
                sub.date = convertDateToString(date: form.datePicker.date)
            }
        }
        
        DataManager.shared.save()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
        NotificationCenter.default.post(name: Notification.Name(NotificationName.updateGoalView), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showDeleteWarning() {
        let ac = UIAlertController(title: "Delete Sub-Goal", message: "Are you sure you want to delete this sub-goal?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteGoal()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(delete)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    private func deleteGoal() {
        let goalToRemove = DataManager.shared.subGoals[goalIndex]
        DataManager.shared.subGoals.remove(at: goalIndex)
        DataManager.shared.persistentContainer.viewContext.delete(goalToRemove)
        DataManager.shared.save()
        NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
        navigationController?.popBack(2)
    }
}

//MARK: Extension that pops more than one view controller
extension UINavigationController {
    func popBack(_ count: Int) {
        guard count > 0 else {
            return assertionFailure("Count can not be a negative value.")
        }
        let index = viewControllers.count - count - 1
        guard index > 0 else {
            return assertionFailure("Not enough View Controllers on the navigation stack.")
        }
        popToViewController(viewControllers[index], animated: true)
    }
}
