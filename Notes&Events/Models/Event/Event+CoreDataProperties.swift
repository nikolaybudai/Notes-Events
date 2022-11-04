//
//  Event+CoreDataProperties.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 28.10.22.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?

}

extension Event : Identifiable {

}
