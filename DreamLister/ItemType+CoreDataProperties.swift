//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Ruben Sissing on 21/04/2017.
//  Copyright © 2017 Ruben Sissing. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
