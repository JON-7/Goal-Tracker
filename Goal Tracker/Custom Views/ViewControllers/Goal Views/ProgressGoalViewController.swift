//
//  ProgressGoalViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class ProgressGoalViewController: UIViewController {
    
    let remaining = UILabel()
    let messageLabel = UILabel()
    var progressView = ProgressBarView(currentNum: 0, endNum: 0, isGainGoal: false)
    var goal: AnyObject!
    
    var goalType: GoalType!
    var progressPercent: Double?
    var goalColor: UIColor!
    var goalIndex: Int!
    
    var currentNum: Double!
    var endNum: Double!
    var isGainGoal: Bool!
    var containsDate: Bool
    var date: String!
    
    init(containsDate: Bool) {
        self.containsDate = containsDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func setValues() {
        if goalType == .main {
            goal = DataManager.shared.goals[goalIndex]
        } else {
            goal = DataManager.shared.subGoals[goalIndex]
        }
        currentNum = goal.startNum
        endNum = goal.endNum
        isGainGoal = goal.isGainGoal
        goalColor = goal.cellColor
        date = goal.date
    }
    
    private func configureView() {
        setValues()
        if containsDate {
            configureProgressView()
            configureCountdown()
        } else {
            configureMessageLabels()
            configureProgressView()
        }
        checkGoalStatus()
    }
    
    private func configureProgressView() {
        let progress = ProgressBarView(currentNum: currentNum, endNum: endNum, isGainGoal: isGainGoal)
        progressView = progress
        progressPercent = progressView.getPercentage(currentNum, endNum, isGainGoal: isGainGoal).percentage
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.shape.strokeColor = goalColor.cgColor
        
        if containsDate {
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -10),
                progressView.heightAnchor.constraint(equalToConstant: view.bounds.width),
                progressView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            ])
        } else {
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -10),
                progressView.heightAnchor.constraint(equalToConstant: view.bounds.width),
                progressView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            ])
            pinMessageLabels()
            
        }
        view.backgroundColor = Colors.mainBackgroundColor
        progressView.backgroundColor = Colors.mainBackgroundColor
    }
    
    private func pinMessageLabels() {
        // if the the device has a small screen then only the remaining will be shown
        if view.bounds.width * 2 > view.bounds.height {
            messageLabel.text = remaining.text
            remaining.text = ""
            
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: progressView.containerView.topAnchor, constant: view.bounds.width/1.9),
                messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: progressView.containerView.topAnchor, constant: view.bounds.width/1.9),
                messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                remaining.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
                remaining.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                remaining.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
    }
    
    private func checkGoalStatus() {
        if let mainGoal = goal as? Goal {
            if progressPercent == 100.0  {
                mainGoal.isGoalComplete = true
            } else if progressPercent ?? 0 >= 0 && progressPercent ?? 0 < 100.0 {
                mainGoal.isGoalComplete = false
            }
            DataManager.shared.save()
        }
        if let subGoal = goal as? SubGoal {
            if progressPercent == 100.0 {
                subGoal.isGoalComplete = true
            } else if progressPercent ?? 0 >= 0 && progressPercent ?? 0 < 100.0 {
                subGoal.isGoalComplete = false
            }
            DataManager.shared.save()
        }
    }
    
    func configureMessageLabels() {
        let messages = ["Great Job!", "Great Work!", "Amazing Work!"]
        view.addSubview(remaining)
        var difference: Double = 0
        if isGainGoal && (currentNum! >= endNum!) {
            remaining.text = messages.randomElement()
        } else if !isGainGoal && (currentNum! <= endNum!) {
            remaining.text = messages.randomElement()
        } else {
            difference = abs(endNum! - currentNum!)
            remaining.text = "\(difference.formatToString) Remaining"
        }
        
        remaining.translatesAutoresizingMaskIntoConstraints = false
        remaining.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/1.6), weight: .semibold)
        remaining.textAlignment = .center
        remaining.numberOfLines = 2
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/1.6), weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        
        // change the message depending on completion percentage
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
        progressPercent = progress.getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage
        if let percentage = Double(progress.getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage.formatToString) {
            switch percentage {
            case 0..<49.9:
                messageLabel.text = "Keep It Going!"
            case 50...55.9:
                messageLabel.text = "Half way there, keep it up!"
            case 56...79.9:
                messageLabel.text = "Doing Great!"
            case 80...99.9:
                messageLabel.text = "Almost there!"
            case 100:
                messageLabel.text = "Goal Complete"
            default:
                messageLabel.text = "Continue"
            }
        }
    }
    
    private func configureCountdown() {
        let countdown = CountdownView(dateString: date)
        countdown.tag = 1
        view.addSubview(countdown)
        countdown.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdown.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 30),
            countdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func updateProgressView() {
        DispatchQueue.main.async { [self] in
            setValues()
            if containsDate {
                configureProgressView()
                configureCountdown()
            } else {
                configureMessageLabels()
                configureProgressView()
            }
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
        }
    }
    
    func updateProgressAndCountdown(goalIndex: Int, goalType: GoalType) {
        DispatchQueue.main.async { [self] in
            if goalType == .main {
                goal = DataManager.shared.goals[goalIndex]
            } else {
                goal = DataManager.shared.subGoals[goalIndex]
            }
            
            currentNum = goal.startNum
            endNum = goal.endNum
            isGainGoal = goal.isGainGoal
            date = goal.date
            configureProgressView()
            progressView.shape.strokeColor = goal.cellColor?.cgColor
            
            if goal.isGoalComplete {
                view.viewWithTag(1)?.removeFromSuperview()
                pinMessageLabels()
                return
            }
            
            if let viewWithTag = self.view.viewWithTag(1) {
                viewWithTag.removeFromSuperview()
                configureCountdown()
            }
        }
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
    }
    
    private func configureAllGoalMessage() {
        configureMessageLabels()
    }
}
