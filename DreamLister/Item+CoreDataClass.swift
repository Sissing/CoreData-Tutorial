//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ruben Sissing on 21/04/2017.
//  Copyright © 2017 Ruben Sissing. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
