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
    var goalType: GoalType!
    var goal: AnyObject!
    var isGoalComplete: Bool!
    let container = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackgroundColor
        configureGoal()
        configureContainerView()
        configureStatusLabel()
        configureGoalNameLabel()
        configureButton()
    }
    
    private func configureGoal() {
        if goalType == .main {
            goal = DataManager.shared.goals[goalIndex]
        } else {
            goal = DataManager.shared.subGoals[goalIndex]
        }
    }
    
    private func configureContainerView() {
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true
    }
    
    private func configureStatusLabel() {
        container.addSubview(goalStatusLabel)
        goalStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        var goalStatusText = "Status: "
        if goal.isGoalComplete {
            goalStatusText = goalStatusText + "Goal Complete"
        } else {
            goalStatusText = goalStatusText + "In Progress"
        }
        goalStatusLabel.text = goalStatusText
        goalStatusLabel.font = UIFont.systemFont(ofSize: view.bounds.height * (0.1/3), weight: .semibold)
        
        NSLayoutConstraint.activate([
            goalStatusLabel.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            goalStatusLabel.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            goalStatusLabel.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func configureGoalNameLabel() {
        container.addSubview(goalNameLabel)
        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        goalNameLabel.textAlignment = .center
        goalNameLabel.font = .monospacedDigitSystemFont(ofSize: view.bounds.height * (0.1/2), weight: .light)
        goalNameLabel.numberOfLines = 7
        goalNameLabel.text = goal.name
        goalNameLabel.textColor = goal.cellColor
        goalNameLabel.backgroundColor = .tertiarySystemBackground
        goalNameLabel.clipsToBounds = true
        goalNameLabel.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            goalNameLabel.topAnchor.constraint(equalTo: goalStatusLabel.bottomAnchor, constant: 20),
            goalNameLabel.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            goalNameLabel.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func configureButton() {
        container.addSubview(completeGoalButton)
        completeGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeGoalButton.topAnchor.constraint(equalTo: goalNameLabel.bottomAnchor, constant: 30),
            completeGoalButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            completeGoalButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            completeGoalButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.09),
            completeGoalButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 10)
        ])

        if goal.isGoalComplete {
            completeGoalButton.setTitle("Complete", for: .normal)
            completeGoalButton.backgroundColor = goal.cellColor
            isGoalComplete = true
        } else {
            completeGoalButton.setTitle("Mark Complete?", for: .normal)
            completeGoalButton.backgroundColor = Colors.completeGoalButtonColor
            isGoalComplete = false
        }
        
        completeGoalButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        if isGoalComplete {
            completeGoalButton.backgroundColor = Colors.completeGoalButtonColor
            completeGoalButton.setTitle("Mark Complete?", for: .normal)
            DispatchQueue.main.async {
                self.goalStatusLabel.text = "Status: In Progress"
            }
            isGoalComplete = false
            
            if let mainGoal = goal as? Goal {
                mainGoal.isGoalComplete = false
            }
            
            if let subGoal = goal as? SubGoal {
                subGoal.isGoalComplete = false
            }

            DataManager.shared.save()
        } else {
            completeGoalButton.backgroundColor = goal.cellColor
            completeGoalButton.setTitle("Complete", for: .normal)
            DispatchQueue.main.async {
                self.goalStatusLabel.text = "Status: Complete"
            }
            isGoalComplete = true
            if let mainGoal = goal as? Goal {
                mainGoal.isGoalComplete = true
            }
            
            if let subGoal = goal as? SubGoal {
                subGoal.isGoalComplete = true
            }
            DataManager.shared.save()
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [self] in
            isGoalComplete = goal.isGoalComplete
            if isGoalComplete {
                goalStatusLabel.text = "Complete"
                completeGoalButton.backgroundColor = goal.cellColor
                completeGoalButton.isSelected = true
            } else {
                goalStatusLabel.text = "In Progress"
                completeGoalButton.backgroundColor = Colors.completeGoalButtonColor
            }
            goalNameLabel.text = goal.name
            goalNameLabel.textColor = goal.cellColor
        }
    }
}
