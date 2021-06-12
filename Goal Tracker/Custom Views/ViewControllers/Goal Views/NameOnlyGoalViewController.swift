//
//  NameOnlyGoalViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class NameOnlyGoalViewController: UIViewController {
    
    let goalStatusLabel = UILabel()
    let goalNameLabel = UILabel()
    let completeGoalButton = GoalButton()
    var goalIndex: Int!
    var isGoalComplete: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackgroundColor
        configureStatusLabel()
        configureText()
        configureButton()
    }
    
    private func configureStatusLabel() {
        view.addSubview(goalStatusLabel)
        goalStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        var goalStatusText = "Status: "
        if DataManager.shared.subGoals[goalIndex].isGoalComplete {
            goalStatusText = goalStatusText + "Goal Complete"
        } else {
            goalStatusText = goalStatusText + "In Progress"
        }
        goalStatusLabel.text = goalStatusText
        goalStatusLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/3), weight: .semibold)
        
        NSLayoutConstraint.activate([
            goalStatusLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            goalStatusLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            goalStatusLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func configureText() {
        view.addSubview(goalNameLabel)
        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        goalNameLabel.textAlignment = .center
        goalNameLabel.font = .monospacedDigitSystemFont(ofSize: UIScreen.main.bounds.height * (0.1/2), weight: .light)
        goalNameLabel.numberOfLines = 0
        goalNameLabel.text = DataManager.shared.subGoals[goalIndex].name
        goalNameLabel.textColor = DataManager.shared.subGoals[goalIndex].cellColor
        goalNameLabel.backgroundColor = .tertiarySystemBackground
        goalNameLabel.clipsToBounds = true
        goalNameLabel.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            goalNameLabel.topAnchor.constraint(equalTo: goalStatusLabel.bottomAnchor, constant: 20),
            goalNameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            goalNameLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func configureButton() {
        view.addSubview(completeGoalButton)
        completeGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeGoalButton.topAnchor.constraint(equalTo: goalNameLabel.bottomAnchor, constant: 30),
            completeGoalButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            completeGoalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeGoalButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.09)
        ])
        
        let subgoal = DataManager.shared.subGoals[goalIndex]
        if subgoal.isGoalComplete {
            completeGoalButton.setTitle("Complete", for: .normal)
            completeGoalButton.backgroundColor = subgoal.cellColor
            isGoalComplete = true
        } else {
            completeGoalButton.setTitle("Mark Complete?", for: .normal)
            completeGoalButton.backgroundColor = .systemGray
            isGoalComplete = false
        }
        
        completeGoalButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        if isGoalComplete {
            completeGoalButton.backgroundColor = .systemGray
            completeGoalButton.setTitle("Mark Complete?", for: .normal)
            DispatchQueue.main.async {
                self.goalStatusLabel.text = "Status: In Progress"
            }
            isGoalComplete = false
            DataManager.shared.subGoals[goalIndex].isGoalComplete = false
            DataManager.shared.save()
        } else {
            completeGoalButton.backgroundColor = DataManager.shared.subGoals[goalIndex].cellColor
            completeGoalButton.setTitle("Complete", for: .normal)
            DispatchQueue.main.async {
                self.goalStatusLabel.text = "Status: Complete"
            }
            isGoalComplete = true
            DataManager.shared.subGoals[goalIndex].isGoalComplete = true
            DataManager.shared.save()
        }
    }
}
