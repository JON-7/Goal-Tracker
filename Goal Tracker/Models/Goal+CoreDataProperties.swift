//
//  Goal+CoreDataProperties.swift
//  Goal Tracker
//
//  Created by Jon E on 3/13/21.
//
//

import Foundation
import CoreData
import UIKit.UIColor

extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var cellColor: UIColor?
    @NSManaged public var date: String?
    @NSManaged public var endNum: Double
    @NSManaged public var isGainGoal: Bool
    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var startNum: Double
    @NSManaged public var isGoalComplete: Bool
    @NSManaged public var notes: NSSet?
    @NSManaged public var subGoals: NSSet?

}

// MARK: Generated accessors for notes
extension Goal {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for subGoals
extension Goal {

    @objc(addSubGoalsObject:)
    @NSManaged public func addToSubGoals(_ value: SubGoal)

    @objc(removeSubGoalsObject:)
    @NSManaged public func removeFromSubGoals(_ value: SubGoal)

    @objc(addSubGoals:)
    @NSManaged public func addToSubGoals(_ values: NSSet)

    @objc(removeSubGoals:)
    @NSManaged public func removeFromSubGoals(_ values: NSSet)

}

extension Goal : Identifiable {

}
