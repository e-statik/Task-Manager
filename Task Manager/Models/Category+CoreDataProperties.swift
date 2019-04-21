//
//  Category+CoreDataProperties.swift
//  Task Manager
//
//  Created by Victor Blokhin on 04/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var color: String?
    @NSManaged public var name: String?
    @NSManaged public var states: NSOrderedSet?
    @NSManaged public var tasks: NSOrderedSet?

}

// MARK: Generated accessors for states
extension Category {

    @objc(insertObject:inStatesAtIndex:)
    @NSManaged public func insertIntoStates(_ value: State, at idx: Int)

    @objc(removeObjectFromStatesAtIndex:)
    @NSManaged public func removeFromStates(at idx: Int)

    @objc(insertStates:atIndexes:)
    @NSManaged public func insertIntoStates(_ values: [State], at indexes: NSIndexSet)

    @objc(removeStatesAtIndexes:)
    @NSManaged public func removeFromStates(at indexes: NSIndexSet)

    @objc(replaceObjectInStatesAtIndex:withObject:)
    @NSManaged public func replaceStates(at idx: Int, with value: State)

    @objc(replaceStatesAtIndexes:withStates:)
    @NSManaged public func replaceStates(at indexes: NSIndexSet, with values: [State])

    @objc(addStatesObject:)
    @NSManaged public func addToStates(_ value: State)

    @objc(removeStatesObject:)
    @NSManaged public func removeFromStates(_ value: State)

    @objc(addStates:)
    @NSManaged public func addToStates(_ values: NSOrderedSet)

    @objc(removeStates:)
    @NSManaged public func removeFromStates(_ values: NSOrderedSet)

}

// MARK: Generated accessors for tasks
extension Category {

    @objc(insertObject:inTasksAtIndex:)
    @NSManaged public func insertIntoTasks(_ value: Task, at idx: Int)

    @objc(removeObjectFromTasksAtIndex:)
    @NSManaged public func removeFromTasks(at idx: Int)

    @objc(insertTasks:atIndexes:)
    @NSManaged public func insertIntoTasks(_ values: [Task], at indexes: NSIndexSet)

    @objc(removeTasksAtIndexes:)
    @NSManaged public func removeFromTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInTasksAtIndex:withObject:)
    @NSManaged public func replaceTasks(at idx: Int, with value: Task)

    @objc(replaceTasksAtIndexes:withTasks:)
    @NSManaged public func replaceTasks(at indexes: NSIndexSet, with values: [Task])

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSOrderedSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSOrderedSet)

}
