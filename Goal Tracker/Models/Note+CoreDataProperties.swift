//
//  Note+CoreDataProperties.swift
//  Goal Tracker
//
//  Created by Jon E on 3/13/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lastEdited: String?
    @NSManaged public var noteText: String?
    @NSManaged public var title: String?
    @NSManaged public var goal: Goal?

}

extension Note : Identifiable {

}
