//
//  NameGoalInfoView.swift
//  Goal Tracker
//
//  Created by Jon E on 6/8/21.
//

import UIKit

class NameGoalInfoView: UIView {

    let containerView = UIView()
    let goalNameLabel = UILabel()
    let completeGoalButton = GoalButton()
    var goalIndex: Int!
    
    init(goalIndex: Int) {
        super.init(frame: .zero)
        self.goalIndex = goalIndex
        configureText()
        //configureButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureText() {
        addSubview(goalNameLabel)
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
            goalNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            goalNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            goalNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            goalNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureButton() {
        addSubview(completeGoalButton)
        completeGoalButton.translatesAutoresizingMaskIntoConstraints = false
        completeGoalButton.setTitle("Complete", for: .normal)
        completeGoalButton.backgroundColor = .systemGreen

        NSLayoutConstraint.activate([
            completeGoalButton.topAnchor.constraint(equalTo: goalNameLabel.bottomAnchor, constant: 20),
            completeGoalButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            completeGoalButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            completeGoalButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * (0.1))
        ])
    }
}
