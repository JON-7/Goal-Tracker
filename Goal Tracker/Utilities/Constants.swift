//
//  Constants.swift
//  Goal Tracker
//
//  Created by Jon E on 3/29/21.
//

import UIKit

enum GoalType {
    case main
    case sub
}

enum Action {
    case create
    case edit
    case none
}

enum Colors {
    static let countdownColor = UIColor(named: "countdownColor")
    static let createGoalLabelColor = UIColor(named: "createGoalLabelColor")
    static let goalActionBtnColor = UIColor(named: "goalActionBtnColor")
    static let mainBackgroundColor = UIColor(named: "mainBackgroundColor")
    static let noteTFColor = UIColor(named: "noteTFColor")
    static let textColor = UIColor(named: "textColor")
}

enum FormErrorType {
    case emptyNameField
    case missingStartNumber
    case missingEndNumber
}

enum NotificationName {
    static let reloadCollectionView = "reloadCollectionViewNotif"
    static let updateGoalView = "updateProgressBarNotif"
}

enum Alerts {
    static let markIncomplete = UIAlertController(title: "Mark As Incomplete?", message: "Do you want to change the status of the goal to INCOMPLETE?", preferredStyle: .alert)
    
    static let markComplete = UIAlertController(title: "Mark As Complete?", message: "Do you want to mark this goal as COMPLETE?", preferredStyle: .alert)
}

enum SFSymbol {
    static let backArrow = UIImage(systemName: "arrow.backward")
    static let pencil = UIImage(systemName: "pencil")
    static let checkmark = UIImage(systemName: "checkmark")
}
