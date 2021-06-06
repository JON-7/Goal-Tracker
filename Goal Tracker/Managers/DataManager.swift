//
//  DataManager.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import Foundation
import CoreData
import UIKit.UIColor

class DataManager {
    
    static let shared = DataManager()
    
    var goals = [Goal]()
    var subGoals = [SubGoal]()
    var notes = [Note]()
    

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Goal_Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func goal(name: String?, date: String?, startNum: Double?, endNum: Double?, cellColor: UIColor, index: Int, isGainGoal: Bool, isGoalComplete: Bool) -> Goal {
        let goal = Goal(context: persistentContainer.viewContext)
        goal.name = name
        goal.date = date
        goal.startNum = startNum ?? 0
        goal.endNum = endNum ?? 0
        goal.cellColor = cellColor
        goal.index = Int16(index)
        goal.isGainGoal = isGainGoal
        goal.isGoalComplete = isGoalComplete
        return goal
    }
    
    func fetchGoals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        let deseptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [deseptor]
        var fetchGoals = [Goal]()
        do {
            fetchGoals = try persistentContainer.viewContext.fetch(request)
        }
        catch {
            print("error fetching budgets")
        }
        return fetchGoals
    }
    
    func subGoal(name: String?, date: String?, startNum: Double?, endNum: Double?, cellColor: UIColor, index: Int, isGainGoal: Bool, isGoalComplete: Bool, goal: Goal) -> SubGoal {
        let subGoal = SubGoal(context: persistentContainer.viewContext)
        subGoal.name = name
        subGoal.date = date
        subGoal.startNum = startNum ?? 0
        subGoal.endNum = endNum ?? 0
        subGoal.cellColor = cellColor
        subGoal.index = Int16(index)
        subGoal.isGainGoal = isGainGoal
        subGoal.isGoalComplete = isGoalComplete
        subGoal.goal = goal
        return subGoal
    }
    
    func note(title: String?, lastEdited: String?, noteText: String?, date: Date?, goal: Goal) -> Note {
        let note = Note(context: persistentContainer.viewContext)
        note.title = title
        note.lastEdited = lastEdited
        note.noteText = noteText
        note.date = date
        note.goal = goal
        return note
    }
    
    // MARK: - Core Data Saving support
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
