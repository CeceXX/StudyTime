//
//  Card+CoreDataProperties.swift
//  StudyTime
//
//  Created by Maximilian Litteral on 10/24/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Card {

    @NSManaged var hint: String
    @NSManaged var answer: String
    @NSManaged var stack: Stack

}
