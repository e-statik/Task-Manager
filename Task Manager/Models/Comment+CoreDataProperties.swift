//
//  Comment+CoreDataProperties.swift
//  Task Manager
//
//  Created by Victor Blokhin on 04/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var content: String?
    @NSManaged public var dateCreated: NSDate?

}
