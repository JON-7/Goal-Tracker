//
//  ViewGoalVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import UIKit

class GoalVC: UIViewController {
    var goalName: String?
    var date: String?
    var currentNum: Double?
    var endNum: Double?
    var currentGoalIndex: Int!
    var isGainGoal: Bool!
    var isComplete: Bool!
    
    let completeButton = UIButton()
    let topCountdownLabel = UILabel()
    let bottomCountdownLabel = UILabel()
    let messageLabel = UILabel()
    let remaining = UILabel()
    let progressLabel = UILabel()
    
    var goalColor: UIColor!
    let label = UILabel()
    var goalType: String!
    var progressPercent: Double?
    
    required init(goalType: String) {
        self.goalType = goalType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("updateGoalUI"), object: nil)
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        configureView()
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async { [self] in
            configLabel()
            if goalType == "sub" {
                goalName = SubGoalsVC.subGoals[currentGoalIndex!].name
                date = SubGoalsVC.subGoals[currentGoalIndex!].date
                currentNum = SubGoalsVC.subGoals[currentGoalIndex!].startNum
                endNum = SubGoalsVC.subGoals[currentGoalIndex!].endNum
                goalColor = SubGoalsVC.subGoals[currentGoalIndex!].cellColor
                isGainGoal = SubGoalsVC.subGoals[currentGoalIndex!].isGainGoal
                configureView()
            } else {
                goalName = HomeVC.goals[currentGoalIndex!].name
                date = HomeVC.goals[currentGoalIndex!].date
                currentNum = HomeVC.goals[currentGoalIndex!].startNum
                endNum = HomeVC.goals[currentGoalIndex!].endNum
                goalColor = HomeVC.goals[currentGoalIndex!].cellColor
                isGainGoal = HomeVC.goals[currentGoalIndex!].isGainGoal
                configureView()
            }
        }
    }
    
    func configureView() {
        if goalColor == nil {
            goalColor = HomeVC.goals[currentGoalIndex].cellColor
        }
        if date != "" && endNum == 0.0 {
            configureCountdown()
        } else if endNum != 0.0 && date == "" {
            configureProgress()
        } else if endNum == 0.0 && date == "" {
            configureGoalTitle()
            configCompleteButton()
        } else {
            configCountdownAndNums()
        }
    }
    
    func configLabel() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureGoalTitle() {
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = goalName
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 3
        messageLabel.font = .preferredFont(forTextStyle: .headline)
        messageLabel.font = .systemFont(ofSize: 40)
        navigationController?.navigationBar.topItem?.title = "Goal"
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
        ])  
    }
    
    func configCompleteButton() {
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.layer.cornerRadius = 30
        completeButton.clipsToBounds = true
        completeButton.setTitle("Complete Goal", for: .normal)
        
        if isComplete {
            completeButton.isSelected = true
            completeButton.backgroundColor = .systemGreen
            if goalType == "main" {
                completeButton.setTitle("Goal Complete", for: .selected)
            } else if goalType == "sub" {
                completeButton.setTitle("Sub-Goal Complete", for: .selected)
            }
            completeButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        } else {
            completeButton.backgroundColor = .lightGray
        }
        
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30),
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
                isComplete = false
                if goalType == "main" {
                    HomeVC.goals[currentGoalIndex!].isGoalComplete = false
                    DataManager.shared.save()
                } else if goalType == "sub" {
                    SubGoalsVC.subGoals[currentGoalIndex!].isGoalComplete = false
                    DataManager.shared.save()
                }
                if date != "" && endNum == 0.0 {
                    configLabel()
                    configureCountdown()
                }
                
            } else {
                self.completeButton.pulsate()
                self.completeButton.isSelected = true
                self.completeButton.backgroundColor = .systemGreen
                self.completeButton.setTitle("Sub-Goal Complete", for: .selected)
                self.completeButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
                self.isComplete = true
                if goalType == "main" {
                    HomeVC.goals[currentGoalIndex!].isGoalComplete = true
                    DataManager.shared.save()
                } else if goalType == "sub" {
                    SubGoalsVC.subGoals[currentGoalIndex!].isGoalComplete = true
                    DataManager.shared.save()
                }
                if date != "" && endNum == 0.0 {
                    configLabel()
                    configureCountdown()
                }
            }
        }
    }
    
    // MARK: Configure the countdown view
    func configureCountdown() {
        let countdown = DaysRemainingView(dateString: date!)
        countdown.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdown)
        
        if isComplete {
            countdown.stopTimer()
            countdown.timeDiff = 0
            countdown.daysView.text = "0"
        }
        
        view.addSubview(topCountdownLabel)
        topCountdownLabel.translatesAutoresizingMaskIntoConstraints = false
        topCountdownLabel.text = "GOAL: \n\(goalName!)"
        topCountdownLabel.numberOfLines = 6
        topCountdownLabel.font = .monospacedSystemFont(ofSize: 25, weight: .thin)
        topCountdownLabel.clipsToBounds = true
        topCountdownLabel.layer.cornerRadius = 10
        topCountdownLabel.backgroundColor = UIColor(named: "countdownColor")
        
        view.addSubview(bottomCountdownLabel)
        bottomCountdownLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomCountdownLabel.textAlignment = .center
        bottomCountdownLabel.font = .boldSystemFont(ofSize: 35)
        
        if isComplete {
            navigationController?.navigationBar.topItem?.title = "Goal Complete"
            bottomCountdownLabel.text = "Complete"
            bottomCountdownLabel.textColor = UIColor(named: "textColor")
        } else {
            navigationController?.navigationBar.topItem?.title = date
            bottomCountdownLabel.text = "Time Remaining"
            if countdown.timeDiff < -1 {
                bottomCountdownLabel.textColor = .systemRed
            }
        }
        
        NSLayoutConstraint.activate([
            topCountdownLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            topCountdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            topCountdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            bottomCountdownLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.bounds.height/2) - 60),
            bottomCountdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomCountdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        configCompleteButton()
    }
    
    
    
    //MARK: Configure the progress bar, message label, and remaining label
    public func configureProgress() {
        let messages = ["Great Job!", "Great Work!", "Amazing Work!"]
        navigationController?.navigationBar.topItem?.title = "Progress"
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
        progressPercent = progress.getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage
        self.view.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.shape.strokeColor = goalColor.cgColor
        
        view.addSubview(remaining)
        var difference: Double = 0
        if isGainGoal && (currentNum! >= endNum!) {
            remaining.text = messages.randomElement()
        } else if !isGainGoal && (currentNum! <= endNum!) {
            remaining.text = messages.randomElement()
        } else {
            difference = abs(endNum! - currentNum!)
            remaining.text = "\(difference.formatToString) Left"
        }
        
        remaining.translatesAutoresizingMaskIntoConstraints = false
        remaining.font = .systemFont(ofSize: 45, weight: .semibold)
        remaining.textAlignment = .center
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .systemFont(ofSize: 45, weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        
        // change the message depending on completion percentage
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
        
        if goalType == "main" {
            if progressPercent == 100.0 {
                HomeVC.goals[currentGoalIndex!].isGoalComplete = true
                DataManager.shared.save()
            } else if progressPercent ?? 0 >= 0 && progressPercent ?? 0 < 100.0 {
                HomeVC.goals[currentGoalIndex!].isGoalComplete = false
                DataManager.shared.save()
            }
        } else if goalType == "sub" {
            if progressPercent == 100.0 {
                SubGoalsVC.subGoals[currentGoalIndex!].isGoalComplete = true
                DataManager.shared.save()
            } else if progressPercent ?? 0 >= 0 && progressPercent ?? 0 < 100.0 {
                SubGoalsVC.subGoals[currentGoalIndex!].isGoalComplete = false
                DataManager.shared.save()
            }
        }
        
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 340),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            remaining.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 3),
            remaining.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remaining.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // setting up both the progress view and the countdown view
    func configCountdownAndNums() {
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
        progressPercent = progress.getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage
        if progress.percentage == "100%" {
            configureProgress()
            return
        }
        
        self.view.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.topItem?.title = "Progress"
        
        progress.shape.strokeColor = goalColor.cgColor
        
        let countdown = DaysRemainingView(dateString: date!)
        view.addSubview(countdown)
        countdown.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countdown.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 100),
            countdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countdown.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension Double {
    var formatToString: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}

extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.9
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
}
