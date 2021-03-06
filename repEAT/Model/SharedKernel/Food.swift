//
//  Food.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import CoreData

extension Food {
    
    convenience init(_ name: String, baseUnit: UnitOfMeasure? = nil, into context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.baseUnit = baseUnit
    }
    
}
