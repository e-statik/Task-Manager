//
//  State+CoreDataProperties.swift
//  Task Manager
//
//  Created by Victor Blokhin on 04/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var isNew: Bool
    @NSManaged public var name: String?
    @NSManaged public var tasks: NSOrderedSet?

}

// MARK: Generated accessors for tasks
extension State {

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
