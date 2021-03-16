//
//  SubGoal+CoreDataProperties.swift
//  Goal Tracker
//
//  Created by Jon E on 3/13/21.
//
//

import Foundation
import CoreData
import UIKit.UIColor

extension SubGoal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubGoal> {
        return NSFetchRequest<SubGoal>(entityName: "SubGoal")
    }

    @NSManaged public var cellColor: UIColor?
    @NSManaged public var date: String?
    @NSManaged public var endNum: Double
    @NSManaged public var isGainGoal: Bool
    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var startNum: Double
    @NSManaged public var isGoalComplete: Bool
    @NSManaged public var goal: Goal?

}

extension SubGoal : Identifiable {

}
