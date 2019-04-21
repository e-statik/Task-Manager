//
//  Task+CoreDataProperties.swift
//  Task Manager
//
//  Created by Victor Blokhin on 05/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var additionalDescription: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateDone: NSDate?
    @NSManaged public var datePlannedEnd: NSDate?
    @NSManaged public var datePlannedStart: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var locationAddress: String?
    @NSManaged public var locationLongitude: Double
    @NSManaged public var locationLatitude: Double
    @NSManaged public var category: Category?
    @NSManaged public var comments: NSOrderedSet?
    @NSManaged public var state: State?

}

// MARK: Generated accessors for comments
extension Task {

    @objc(insertObject:inCommentsAtIndex:)
    @NSManaged public func insertIntoComments(_ value: Comment, at idx: Int)

    @objc(removeObjectFromCommentsAtIndex:)
    @NSManaged public func removeFromComments(at idx: Int)

    @objc(insertComments:atIndexes:)
    @NSManaged public func insertIntoComments(_ values: [Comment], at indexes: NSIndexSet)

    @objc(removeCommentsAtIndexes:)
    @NSManaged public func removeFromComments(at indexes: NSIndexSet)

    @objc(replaceObjectInCommentsAtIndex:withObject:)
    @NSManaged public func replaceComments(at idx: Int, with value: Comment)

    @objc(replaceCommentsAtIndexes:withComments:)
    @NSManaged public func replaceComments(at indexes: NSIndexSet, with values: [Comment])

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSOrderedSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSOrderedSet)

}
