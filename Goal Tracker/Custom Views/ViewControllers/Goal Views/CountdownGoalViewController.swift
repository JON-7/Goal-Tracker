//
//  CountdownGoalViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class CountdownGoalViewController: UIViewController {
    
    var goal: AnyObject!
    var countdown = CountdownView()
    let completeButton = GoalButton()
    var goalType: GoalType!
    var goalIndex: Int!
    var isComplete: Bool!
    
    let goalTitleLabel = UILabel()
    let goalDateLabel = UILabel()
    let datePassedLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackgroundColor
        configureGoal()
        configureCountdown()
        configureTitleDateLabels()
        configureCompleteButton()
    }
    
    private func configureGoal() {
        if goalType == .main {
            goal = DataManager.shared.goals[goalIndex]
            completeButton.setTitle("Complete Goal", for: .normal)
        } else {
            goal = DataManager.shared.subGoals[goalIndex]
            completeButton.setTitle("Complete Sub-Goal", for: .normal)
        }
    }
    
    private func configureCountdown() {
        let countdownView = CountdownView(dateString: goal.date!)
        isComplete = goal.isGoalComplete
        countdown = countdownView
        goalTitleLabel.text = goal.name
        goalDateLabel.text = goal.date
        goalDateLabel.textColor = goal.cellColor
        countdown.setCountdownTextColor(goal: goal)
        checkGoalStatus()
        
        view.addSubview(countdown)
        countdown.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countdown.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/4),
            countdown.heightAnchor.constraint(equalToConstant: view.bounds.height/8)
        ])
    }
    
    private func configureCompleteButton() {
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.layer.cornerRadius = 30
        completeButton.clipsToBounds = true
        
        if isComplete {
            completeButton.isSelected = true
            completeButton.backgroundColor = .systemGreen
            if goalType == .main {
                completeButton.setTitle("Goal Complete", for: .selected)
            } else if goalType == .sub {
                completeButton.setTitle("Sub-Goal Complete", for: .selected)
            }
            completeButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        } else {
            completeButton.backgroundColor = .lightGray
        }
        
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            completeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        completeButton.addTarget(self, action: #selector(completePressed), for: .touchUpInside)
    }
    
    @objc func completePressed() {
        DispatchQueue.main.async { [self] in
            if self.isComplete {
                completeButton.pulsate()
                completeButton.isSelected = false
                completeButton.backgroundColor = .lightGray
                goalDateLabel.text = goal.date
                isComplete = false
                
                if goalType == GoalType.main {
                    DataManager.shared.goals[goalIndex].isGoalComplete = false
                    DataManager.shared.save()
                } else if goalType == GoalType.sub {
                    DataManager.shared.subGoals[goalIndex].isGoalComplete = false
                    DataManager.shared.save()
                }
                
                continueCountdown()
                
            } else {
                completeButton.pulsate()
                completeButton.isSelected = true
                completeButton.backgroundColor = .systemGreen
                completeButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
                goalDateLabel.text = "GOAL COMPLETE"
                isComplete = true
                
                stopCountdown()
                
                if goalType == GoalType.main {
                    DataManager.shared.goals[goalIndex].isGoalComplete = true
                    DataManager.shared.save()
                } else if goalType == GoalType.sub {
                    DataManager.shared.subGoals[goalIndex].isGoalComplete = true
                    DataManager.shared.save()
                }
            }
        }
    }
    
    private func configureTitleDateLabels() {
        view.addSubview(goalTitleLabel)
        goalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        goalTitleLabel.numberOfLines = 2
        goalTitleLabel.textAlignment = .center
        goalTitleLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/2), weight: .medium)
        
        view.addSubview(goalDateLabel)
        goalDateLabel.translatesAutoresizingMaskIntoConstraints = false
        goalDateLabel.textAlignment = .center
        goalDateLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/2), weight: .thin)
        
        NSLayoutConstraint.activate([
            goalTitleLabel.topAnchor.constraint(equalTo: countdown.bottomAnchor, constant: 40),
            goalTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalTitleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0),
            goalTitleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            goalDateLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 10),
            goalDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if countdown.timeDiff < -1 {
            configureDatePassedLabel()
        }
    }
    
    private func configureDatePassedLabel() {
        goalTitleLabel.text = "Since"
    }
    
    private func checkGoalStatus() {
        if goal.isGoalComplete {
            stopCountdown()
            goalDateLabel.text = "GOAL COMPLETE"
        }
    }
    
    func stopCountdown() {
        countdown.timer.invalidate()
        DispatchQueue.main.async { [self] in
            self.countdown.daysView.timeRemaining.text = "0"
            self.countdown.hoursView.timeRemaining.text = "0"
            self.countdown.minutesView.timeRemaining.text = "0"
            self.countdown.secondsView.timeRemaining.text = "0"
        }
    }
    
    private func continueCountdown() {
        // starts a new timer
        countdown.startTimer()
    }
    
    func updateView() {
        countdown.dateString = goal.date
        goalDateLabel.text = goal.date
        goalDateLabel.textColor = goal.cellColor
        goalTitleLabel.text = goal.name
        countdown.setCountdownTextColor(goal: goal)
    }
}
