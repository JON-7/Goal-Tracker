//
//  CreateGoalViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class CreateGoalViewController: UIViewController {
    
    var goalIndex: Int!
    var action: Action!
    var goalType: GoalType!
    
    var emptyGoalForm = GoalFormViewController(action: .create, goalType: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEmptyForm()
    }
    
    private func addEmptyForm() {
        emptyGoalForm = GoalFormViewController(action: .create, goalType: goalType)
        addChild(emptyGoalForm)
        view.addSubview(emptyGoalForm.view)
        emptyGoalForm.isGainGoal = true
        emptyGoalForm.didMove(toParent: self)
        emptyGoalForm.view.frame = view.bounds
        emptyGoalForm.createButton.addTarget(self, action: #selector(createGoal), for: .touchUpInside)
    }
    
    @objc private func createGoal() {
        let goalName = emptyGoalForm.goalNameField.goalTF.text
        var goalDate = ""
        
        if !emptyGoalForm.datePicker.isHidden {
            goalDate = convertDateToString(date: emptyGoalForm.datePicker.date)
        }
        
        let currentNumber = Double(emptyGoalForm.currentNumberField.goalTF.text!) ?? 0
        let goalNumber = Double(emptyGoalForm.goalNumberField.goalTF.text!) ?? 0
        
        let goalColor = emptyGoalForm.color ?? UIColor.lightGray
        let isGainGoal = emptyGoalForm.isGainGoal!
        
        // checking to see if all needed fields contain data
        guard emptyGoalForm.isAllDataValid() else { return }
        
        if goalType == .main {
            let goal = DataManager.shared.goal(name: goalName, date: goalDate, startNum: currentNumber, endNum: goalNumber, cellColor: goalColor, index: DataManager.shared.goals.count, isGainGoal: isGainGoal, isGoalComplete: false)
            
            DataManager.shared.goals.append(goal)
            DataManager.shared.save()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
            
            let tabBar = GoalTabBarController(goalIndex: goalIndex)
            var controllers = self.navigationController?.viewControllers
            controllers?.removeAll(where: { $0 is CreateGoalViewController })
            controllers?.append(tabBar)
            if let controllers = controllers {
                self.navigationController?.setViewControllers(controllers, animated: true)
            }
        } else {
            let subGoal = DataManager.shared.subGoal(name: goalName, date: goalDate, startNum: currentNumber, endNum: goalNumber, cellColor: goalColor, index: DataManager.shared.subGoals.count, isGainGoal: isGainGoal, isGoalComplete: false, goal: DataManager.shared.goals[goalIndex])
            
            DataManager.shared.subGoals.append(subGoal)
            DataManager.shared.save()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
            
            let vc = GoalInfoViewController(goalIndex: DataManager.shared.subGoals.count-1, goalType: .sub)
            vc.navigationController?.navigationBar.prefersLargeTitles = true
            vc.title = "Sub-Goal"
            
            var controllers = self.navigationController?.viewControllers
            controllers?.removeAll(where: { $0 is CreateGoalViewController })
            controllers?.append(vc)
            if let controllers = controllers {
                self.navigationController?.setViewControllers(controllers, animated: true)
            }
            
        }
    }
}

extension UINavigationController {
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
