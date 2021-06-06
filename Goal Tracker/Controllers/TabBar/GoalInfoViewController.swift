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
    let progressViewController = ProgressGoalViewController(containsDate: false)
    let progressCountdownViewController = ProgressGoalViewController(containsDate: true)
    let countdownViewController = CountdownGoalViewController()
    let nameOnlyViewController = NameOnlyGoalViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name(NotificationName.updateGoalView), object: nil)
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
        if goal.date != "" && goal.endNum == 0.0 {
            configureCountdownView()
            title = "Goal"
        } else if goal.endNum != 0.0 && goal.date == "" {
            configureProgressBarView()
            title = "Progress"
        } else if goal.endNum == 0.0 && goal.date == "" {
            configureNameOnlyView()
            title = "Sub-Goal"
        } else {
            configureAllFieldsView()
            title = "Progress"
        }
    }
    
    //MARK: Displays a progress bar
    func configureProgressBarView() {
        progressViewController.goalIndex = goalIndex
        progressViewController.goalType = goalType
        progressViewController.view.backgroundColor = Colors.mainBackgroundColor
        addChild(progressViewController)
        view.addSubview(progressViewController.view)
        progressViewController.view.frame = view.bounds
        progressViewController.didMove(toParent: self)
    }
    
    //MARK: Displays how much time is left to complete the goal
    private func configureCountdownView() {
        countdownViewController.goalIndex = goalIndex
        countdownViewController.goalType = goalType
        addChild(countdownViewController)
        view.addSubview(countdownViewController.view)
        countdownViewController.view.bounds = view.bounds
        countdownViewController.didMove(toParent: self)
    }
    
    //MARK: Displays goal name
    private func configureNameOnlyView() {
        nameOnlyViewController.goalIndex = goalIndex
        addChild(nameOnlyViewController)
        view.addSubview(nameOnlyViewController.view)
        nameOnlyViewController.view.bounds = view.bounds
        nameOnlyViewController.didMove(toParent: self)
    }
    
    //MARK: Displays both time remaining and a progress bar
    private func configureAllFieldsView() {
        progressCountdownViewController.goalType = goalType
        progressCountdownViewController.goalIndex = goalIndex
        
        addChild(progressCountdownViewController)
        view.addSubview(progressCountdownViewController.view)
        progressCountdownViewController.view.frame = view.frame
        progressCountdownViewController.didMove(toParent: self)
    }
    
    @objc func updateView() {
        DispatchQueue.main.async { [self] in
            if goal.date != "" && goal.endNum == 0.0 {
                configureCountdownView()
                countdownViewController.updateView()
            } else if goal.endNum != 0.0 && goal.date == "" {
                configureProgressBarView()
                progressViewController.updateProgressView()
            } else if goal.endNum == 0.0 && goal.date == "" {
                configureNameOnlyView()
            } else {
                configureAllFieldsView()
                progressCountdownViewController.updateProgressAndCountdown(goalIndex: goalIndex, goalType: .main)
            }
        }
    }
}
