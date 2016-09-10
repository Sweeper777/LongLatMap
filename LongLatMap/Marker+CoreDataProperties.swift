//
//  Marker+CoreDataProperties.swift
//  LongLatMap
//
//  Created by Mulang Su on 9/10/16.
//  Copyright © 2016 Mulang Su. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Marker {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var color: NSNumber?
    @NSManaged var title: String?
    @NSManaged var desc: String?

}
