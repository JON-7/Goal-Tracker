//
//  GoalTabBarController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalTabBarController: UITabBarController {
    
    var goalIndex: Int!
    var goalInfoViewController = GoalInfoViewController(goalIndex: 0, goalType: .main)
    let subGoalsViewController = SubGoalViewController()
    let notesViewController = NotesViewController()
    let goal: AnyObject!
    let form = GoalFormViewController(action: .edit, goalType: .main)
    var tabBarImages = [String]()
    var onlyContainsName = false
    var currentTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    required init(goalIndex: Int) {
        self.goalIndex = goalIndex
        self.goal = DataManager.shared.goals[goalIndex]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTabBar() {
        goalInfoViewController.title = "Goal"
        subGoalsViewController.title = "Sub-Goals"
        notesViewController.title = "Notes"
        
        goalInfoViewController.goalIndex = goalIndex
        subGoalsViewController.goalIndex = goalIndex
        notesViewController.goalIndex = goalIndex
        
        goalInfoViewController.tabBarItem.tag = 0
        subGoalsViewController.tabBarItem.tag = 1
        notesViewController.tabBarItem.tag = 2
        setTabBarViews()
        
        navigationItem.rightBarButtonItem = .init(image: SFSymbol.pencil, style: .plain, target: self, action: #selector(editGoal))
        
        guard let items = tabBar.items else { return }
        for n in 0..<items.count {
            items[n].image = UIImage(systemName: tabBarImages[n])
        }
        modalPresentationStyle = .fullScreen
    }
    
    private func setTabBarViews() {
        setViewControllers([goalInfoViewController, subGoalsViewController, notesViewController], animated: true)
        tabBarImages = ["scroll.fill","applescript", "note.text"]
        setTitle()
    }
    
    @objc func editGoal() {
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
            form.containsDate = true
            form.datePicker.date = convertStringToDate(stringDate: goal.date ?? "")
            DispatchQueue.main.async { [self] in
                form.dateFieldButton.setTitle("", for: .normal)
            }
        }
        
        if goal.isGoalComplete {
            form.isGoalComplete = true
        }
        
        form.goalNameField.goalTF.text = goal.name
        form.color = goal.cellColor
        form.isGainGoal = goal.isGainGoal
        form.createButton.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
        form.deleteButton.addTarget(self, action: #selector(showWarning), for: .touchUpInside)
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
        navigationController?.pushViewController(form, animated: true)
    }
    
    @objc private func saveInfo() {
        guard form.isAllDataValid() else { return }
        if let mainGoal = goal as? Goal {
            mainGoal.name = form.goalNameField.goalTF.text
            mainGoal.startNum = Double(form.currentNumberField.goalTF.text!) ?? 0
            mainGoal.endNum = Double(form.goalNumberField.goalTF.text!) ?? 0
            mainGoal.cellColor = form.color
            mainGoal.isGainGoal = form.isGainGoal
            
            if form.datePicker.isHidden {
                mainGoal.date = ""
            } else {
                mainGoal.date = convertDateToString(date: form.datePicker.date)
            }
        }
        DataManager.shared.save()
        postNotifications()
        navigationController?.popViewController(animated: true)
    }
    
    private func postNotifications() {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
        NotificationCenter.default.post(name: Notification.Name(NotificationName.updateGoalView), object: nil)
    }
    
    
    @objc private func showWarning() {
        let ac = UIAlertController(title: "Delete Goal", message: "Are you sure you want to delete this goal?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteGoal()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(delete)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    private func deleteGoal() {
        let goalToRemove = DataManager.shared.goals[goalIndex]
        DataManager.shared.goals.remove(at: goalIndex)
        DataManager.shared.persistentContainer.viewContext.delete(goalToRemove)
        DataManager.shared.save()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func showNotes() {
        notesViewController.createNote()
    }
    
    private func setTitle() {
        let goal = DataManager.shared.goals[goalIndex]
        if goal.date != "" && goal.endNum == 0.0 {
            currentTitle = "Countdown"
            title = currentTitle
        } else if goal.endNum != 0.0 && goal.date == "" {
            currentTitle = "Progress"
            title = currentTitle
        } else if goal.endNum == 0.0 && goal.date == "" {
            currentTitle = "Goal"
            title = currentTitle
        } else {
            currentTitle = "Progress"
            title = currentTitle
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            navigationController?.navigationBar.topItem?.title = currentTitle
            navigationItem.rightBarButtonItem = .init(image: SFSymbol.pencil, style: .plain, target: self, action: #selector(editGoal))
        } else if item.tag == 1 {
            navigationController?.navigationBar.topItem?.title = "Sub-Goals"
            if onlyContainsName {
                navigationItem.rightBarButtonItem = .init(image: SFSymbol.pencil, style: .plain, target: self, action: #selector(editGoal))
            } else {
                navigationItem.rightBarButtonItem = .none
            }
        } else if item.tag == 2 {
            navigationController?.navigationBar.topItem?.title = "Notes"
            navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(showNotes))
        }
    }
}
