//
//  NameOnlyGoalViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class NameOnlyGoalViewController: UIViewController {
    
    let goalTitleLabel = UILabel()
    let statusLabel = UILabel()
    let completeGoalButton = GoalButton()
    var goalIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackgroundColor
        configureTitleLabel()
        configureStatusLabel()
        configureCompleteButton()
    }
    
    private func configureTitleLabel() {
        view.addSubview(goalTitleLabel)
        goalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        goalTitleLabel.text = DataManager.shared.subGoals[goalIndex].name
        goalTitleLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/2), weight: .medium)
        goalTitleLabel.clipsToBounds = true
        goalTitleLabel.layer.cornerRadius = 10
        goalTitleLabel.textAlignment = .center
        goalTitleLabel.numberOfLines = 0
        goalTitleLabel.layer.borderWidth = 2
        goalTitleLabel.layer.borderColor = DataManager.shared.subGoals[goalIndex].cellColor?.cgColor
        
        NSLayoutConstraint.activate([
            goalTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            goalTitleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            goalTitleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func configureStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/3), weight: .medium)
        
        if DataManager.shared.subGoals[goalIndex].isGoalComplete {
            statusLabel.text = "Goal Status: Complete"
        } else {
            statusLabel.text = "Goal Status: Incomplete"
        }
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func configureCompleteButton() {
        view.addSubview(completeGoalButton)
        completeGoalButton.translatesAutoresizingMaskIntoConstraints = false
        completeGoalButton.setTitle("Complete", for: .normal)
        completeGoalButton.backgroundColor = .systemGreen
        
        NSLayoutConstraint.activate([
            completeGoalButton.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 20),
            completeGoalButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            completeGoalButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            completeGoalButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
}
