//
//  ViewSubGoalVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/16/21.
//

import UIKit

class ViewSubGoalVC: UIViewController {
    
    var goalName: String!
    var date: String?
    var currentNum: Double?
    var endNum: Double?
    
    var goalDate: Date?
    var currentGoalIndex: Int!
    var subgoalColor: UIColor!
    var isGainGoal: Bool!
    let goalVC = GoalVC(goalType: "sub")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        goalVC.navigationController?.navigationBar.prefersLargeTitles = true
        addGoalVC()
        configureGoalVC()
    }
    
    func addGoalVC() {
        addChild(goalVC)
        
        goalVC.goalName = goalName
        goalVC.date = date
        goalVC.currentNum = currentNum
        goalVC.endNum = endNum
        goalVC.currentGoalIndex = currentGoalIndex
        goalVC.goalColor = subgoalColor
        goalVC.isGainGoal = isGainGoal
        view.addSubview(goalVC.view)
        goalVC.didMove(toParent: self)
        configureGoalVC()
    }
    
    func configureGoalVC() {
        goalVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goalVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            goalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
