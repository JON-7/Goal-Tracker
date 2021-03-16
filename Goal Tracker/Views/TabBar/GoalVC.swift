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
    
    var untilLabel = UILabel()
    var dateLabel = UILabel()
    var messageLabel = UILabel()
    var remaining = UILabel()
    var progressLabel = UILabel()
    
    var goalColor: UIColor!
    let label = UILabel()
    var goalType: String!
    
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
                goalName = SubGoalsVC.subGoals[currentGoalIndex!].date
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
    
    // MARK: Configure the countdown view
    func configureCountdown() {
        let countdown = DaysRemainingView(dateString: date!)
        countdown.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdown)
        navigationController?.navigationBar.topItem?.title = date

        NSLayoutConstraint.activate([
            countdown.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            countdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        configureDateGoalLabel()
        configureUntilLabel()
        
        
        
    }
    
    func configureDateGoalLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = goalName
        dateLabel.textAlignment = .center
        dateLabel.font = .preferredFont(forTextStyle: .headline)
        dateLabel.font = .systemFont(ofSize: 35)
        dateLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75),
            dateLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configureUntilLabel() {
        view.addSubview(untilLabel)
        untilLabel.translatesAutoresizingMaskIntoConstraints = false
        untilLabel.text = "Left To"
        untilLabel.font = .boldSystemFont(ofSize: 40)
        untilLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            untilLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            untilLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            untilLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: Configure the progress bar, message label, and remaining label
    public func configureProgress() {
        let messages = ["Great Job!", "Great Work!", "Amazing Work!"]
        navigationController?.navigationBar.topItem?.title = "Progress"
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
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
        remaining.font = .systemFont(ofSize: 50, weight: .semibold)
        remaining.textAlignment = .center
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .systemFont(ofSize: 50, weight: .semibold)
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
        
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 340),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            remaining.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            remaining.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remaining.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // setting up both the progress view and the countdown view
    func configCountdownAndNums() {
        let progress = ProgressBarView(currentNum: currentNum!, endNum: endNum!, isGainGoal: isGainGoal)
        
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
            
            countdown.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 250),
            countdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countdown.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    deinit {
        print("no retain cycle here.")
    }
}

extension Double {
    var formatToString: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
