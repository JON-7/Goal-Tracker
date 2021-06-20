//
//  GoalInfoViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalInfoViewController: UIViewController {
    
    var goalIndex: Int
    var goalType: GoalType
    var goal: AnyObject!
    let form = GoalFormViewController(action: .edit, goalType: .sub)
    private let progressViewController = ProgressGoalViewController(containsDate: false)
    private let progressCountdownViewController = ProgressGoalViewController(containsDate: true)
    private let countdownViewController = CountdownGoalViewController()
    private let nameOnlyViewController = NameOnlyGoalViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateGoalView), name: Notification.Name(NotificationName.updateGoalView), object: nil)
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
    }
    
    init(goalIndex: Int, goalType: GoalType) {
        self.goalIndex = goalIndex
        self.goalType = goalType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureGoal()
        configureMainGoalView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(image: SFSymbol.pencil, style: .plain, target: self, action: #selector(showUpdateForm))
    }
    
    private func configureGoal() {
        if goalType == .main {
            goal = DataManager.shared.goals[goalIndex]
        } else {
            goal = DataManager.shared.subGoals[goalIndex]
        }
    }
    
    private func configureMainGoalView() {
        //displays countdown view
        if goal.date != "" && goal.endNum == 0.0 {
            configureCountdownView()
            title = "Goal"
        //displays progress bar view
        } else if goal.endNum != 0.0 && goal.date == "" {
            configureProgressBarView()
            title = "Progress"
        //displays name only view
        } else if goal.endNum == 0.0 && goal.date == "" {
            configureNameOnlyView()
            title = "Sub-Goal"
        //displays view with progress bar and countdown
        } else {
            configureProgressAndCountdown()
            title = "Progress"
        }
    }
    
    func configureProgressBarView() {
        progressViewController.goalIndex = goalIndex
        progressViewController.goalType = goalType
        progressViewController.view.backgroundColor = Colors.mainBackgroundColor
        addChild(progressViewController)
        view.addSubview(progressViewController.view)
        progressViewController.view.frame = view.bounds
        progressViewController.didMove(toParent: self)
    }
    
    private func configureCountdownView() {
        countdownViewController.goalIndex = goalIndex
        countdownViewController.goalType = goalType
        addChild(countdownViewController)
        view.addSubview(countdownViewController.view)
        countdownViewController.view.bounds = view.bounds
        countdownViewController.didMove(toParent: self)
    }
    
    private func configureNameOnlyView() {
        nameOnlyViewController.goalIndex = goalIndex
        nameOnlyViewController.goalType = goalType
        addChild(nameOnlyViewController)
        view.addSubview(nameOnlyViewController.view)
        nameOnlyViewController.view.bounds = view.bounds
        nameOnlyViewController.didMove(toParent: self)
    }
    
    private func configureProgressAndCountdown() {
        progressCountdownViewController.goalType = goalType
        progressCountdownViewController.goalIndex = goalIndex
        addChild(progressCountdownViewController)
        view.addSubview(progressCountdownViewController.view)
        progressCountdownViewController.view.frame = view.frame
        progressCountdownViewController.didMove(toParent: self)
    }
    
    //chang goal status to false when changing the goal type
    private func setGoalStatusToFalse() {
        if let mainGoal = goal as? Goal {
            mainGoal.isGoalComplete = false
        }
        
        if let subGoal = goal as? SubGoal {
            subGoal.isGoalComplete = false
        }
        DataManager.shared.save()
    }
    
    @objc func updateGoalView() {
        DispatchQueue.main.async { [self] in
            if goal.date != "" && goal.endNum == 0.0 {
                setGoalStatusToFalse()
                configureCountdownView()
                countdownViewController.isComplete = false
                countdownViewController.updateView()
            } else if goal.endNum != 0.0 && goal.date == "" {
                configureProgressBarView()
                progressViewController.updateProgressView()
                if progressViewController.progressView.percentage != "100%" {
                    setGoalStatusToFalse()
                }
            } else if goal.endNum == 0.0 && goal.date == "" {
                configureNameOnlyView()
                nameOnlyViewController.updateView()
            }
            else {
                if progressViewController.progressView.percentage != "100%" {
                    setGoalStatusToFalse()
                }
                configureProgressAndCountdown()
                progressCountdownViewController.updateProgressAndCountdown(goalIndex: goalIndex, goalType: goalType)
            }
        }
    }
}
