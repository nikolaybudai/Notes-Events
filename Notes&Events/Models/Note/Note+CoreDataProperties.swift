//
//  Note+CoreDataProperties.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 28.10.22.
//
//

import Foundation
import CoreData

@objc enum PriorityType: Int16 {
    
    case low = 0
    case middle = 1
    case high = 2
    
}

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var text: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged var priority: PriorityType
    
}

extension Note : Identifiable {

}
