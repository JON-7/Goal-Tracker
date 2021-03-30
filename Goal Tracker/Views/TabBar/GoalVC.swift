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
    var goalType: GoalType
    var progressPercent: Double?
    var countdown = DaysRemainingView(dateString: "")
    
    required init(goalType: GoalType) {
        self.goalType = goalType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = view
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name(NotificationName.updateUI), object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = Colors.mainBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        countdown = DaysRemainingView(dateString: date!)
        configureView()
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async { [self] in
            configLabel()
            if goalType == GoalType.sub {
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
        label.backgroundColor = Colors.mainBackgroundColor
        
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
        if goalType ==  GoalType.main {
            navigationController?.navigationBar.topItem?.title = "Goal"
        } else {
            self.parent?.title = "Goal"
        }
        
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
            if goalType == GoalType.main {
                completeButton.setTitle("Goal Complete", for: .selected)
            } else if goalType == GoalType.sub {
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
                if goalType == GoalType.main {
                    HomeVC.goals[currentGoalIndex!].isGoalComplete = false
                    DataManager.shared.save()
                } else if goalType == GoalType.sub {
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
                if goalType == GoalType.main {
                    HomeVC.goals[currentGoalIndex!].isGoalComplete = true
                    DataManager.shared.save()
                } else if goalType == GoalType.sub {
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
        let countdownSingle = DaysRemainingView(dateString: date!)
        addChild(countdownSingle)
        view.addSubview(countdownSingle.view)
        countdownSingle.didMove(toParent: self)
        countdownSingle.view.translatesAutoresizingMaskIntoConstraints = false
        
        if isComplete {
            countdownSingle.stopTimer()
            countdownSingle.timeDiff = 0
        }
        
        view.addSubview(topCountdownLabel)
        topCountdownLabel.translatesAutoresizingMaskIntoConstraints = false
        topCountdownLabel.text = "GOAL: \n\(goalName!)"
        topCountdownLabel.numberOfLines = 6
        topCountdownLabel.font = .monospacedSystemFont(ofSize: 25, weight: .thin)
        topCountdownLabel.clipsToBounds = true
        topCountdownLabel.layer.cornerRadius = 10
        topCountdownLabel.backgroundColor = Colors.countdownColor
        
        view.addSubview(bottomCountdownLabel)
        bottomCountdownLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomCountdownLabel.textAlignment = .center
        bottomCountdownLabel.font = .boldSystemFont(ofSize: 35)
        bottomCountdownLabel.text = "Time Remaining"
        
        if isComplete {
            if goalType == GoalType.main {
                navigationController?.navigationBar.topItem?.title = "Goal Complete"
            } else {
                self.parent?.title = "Goal Complete"
            }
            bottomCountdownLabel.textColor = Colors.textColor
        } else {
            if goalType == GoalType.main {
                navigationController?.navigationBar.topItem?.title = date
            } else {
                self.parent?.title = date
            }
            
            if countdownSingle.timeDiff < -1 {
                bottomCountdownLabel.textColor = .systemRed
            }
        }
        
        NSLayoutConstraint.activate([
            topCountdownLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            topCountdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            topCountdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            bottomCountdownLabel.topAnchor.constraint(equalTo: topCountdownLabel.bottomAnchor, constant: 50),
            bottomCountdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomCountdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            countdownSingle.view.topAnchor.constraint(equalTo: bottomCountdownLabel.bottomAnchor, constant: view.bounds.height/10),
            countdownSingle.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdownSingle.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        configCompleteButton()
    }
    
    //MARK: Configure the progress bar, message label, and remaining label
    public func configureProgress() {
        if goalType == GoalType.main {
            navigationController?.navigationBar.topItem?.title = "Progress"
        } else {
            self.parent?.title = "Progress"
        }
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
        progressPercent = progress.getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage
        self.view.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.shape.strokeColor = goalColor.cgColor
        
        if goalType == GoalType.main {
            if progressPercent == 100.0 {
                HomeVC.goals[currentGoalIndex!].isGoalComplete = true
                DataManager.shared.save()
            } else if progressPercent ?? 0 >= 0 && progressPercent ?? 0 < 100.0 {
                HomeVC.goals[currentGoalIndex!].isGoalComplete = false
                DataManager.shared.save()
            }
        } else if goalType == GoalType.main {
            if progressPercent == 100.0 {
                SubGoalsVC.subGoals[currentGoalIndex!].isGoalComplete = true
                DataManager.shared.save()
            } else if progressPercent ?? 0 >= 0 && progressPercent ?? 0 < 100.0 {
                SubGoalsVC.subGoals[currentGoalIndex!].isGoalComplete = false
                DataManager.shared.save()
            }
        }
        
        configMessageLabels()
        
        NSLayoutConstraint.activate([
            progress.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (view.bounds.height/4) + topbarHeight + 10),
            progress.containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/2),
            progress.containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progress.containerView.heightAnchor.constraint(equalToConstant: view.bounds.width),
            
            messageLabel.topAnchor.constraint(equalTo: progress.containerView.topAnchor, constant: view.bounds.width/1.8),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            remaining.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            remaining.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remaining.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func configMessageLabels() {
        let messages = ["Great Job!", "Great Work!", "Amazing Work!"]
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
    
    // setting up both the progress view and the countdown view
    func configCountdownAndNums() {
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
        progressPercent = progress.getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage
        progress.shape.strokeColor = goalColor.cgColor
        progress.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progress)
        
        if goalType == GoalType.main {
            navigationController?.navigationBar.topItem?.title = "Progress"
        } else {
            self.parent?.title = "Progress"
        }
        
        if progress.percentage == "100%" {
            configMessageLabels()
            NSLayoutConstraint.activate([
                progress.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (view.bounds.height/4) + topbarHeight + 10),
                progress.containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/2),
                progress.containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                progress.containerView.heightAnchor.constraint(equalToConstant: view.bounds.width),
                
                messageLabel.topAnchor.constraint(equalTo: progress.containerView.topAnchor, constant: view.bounds.width/1.8),
                messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                remaining.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
                remaining.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                remaining.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        } else {
            view.addSubview(bottomCountdownLabel)
            bottomCountdownLabel.translatesAutoresizingMaskIntoConstraints = false
            bottomCountdownLabel.text = "Time Remaining"
            bottomCountdownLabel.textAlignment = .center
            bottomCountdownLabel.font = .boldSystemFont(ofSize: 35)
            
            addChild(countdown)
            view.addSubview(countdown.view)
            countdown.didMove(toParent: self)
            countdown.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                progress.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (view.bounds.height/4) + topbarHeight + 10),
                progress.containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/2),
                progress.containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                progress.containerView.heightAnchor.constraint(equalToConstant: view.bounds.width),
                
                bottomCountdownLabel.topAnchor.constraint(equalTo: progress.containerView.topAnchor, constant: view.bounds.width/1.85),
                bottomCountdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                bottomCountdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                
                countdown.view.bottomAnchor.constraint(equalTo: bottomCountdownLabel.bottomAnchor, constant: view.bounds.height/10),
                countdown.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                countdown.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
    }
}

extension Double {
    var formatToString: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
