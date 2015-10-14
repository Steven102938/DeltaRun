//
//  RunInfo.swift
//  Run
//
//  Created by Steven Li on 10/8/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import CoreData

class RunInfo: NSManagedObject {

    @NSManaged var distance: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var image: NSData
    @NSManaged var name: String
    @NSManaged var timestamp: NSDate
    @NSManaged var locations: NSOrderedSet

}
extension RunInfo {
    func addLocationObject(value:Location) {
        var items = self.mutableSetValueForKey("locations");
        items.addObject(value)
    }
    
    func removeLocationObject(value:Location) {
        var items = self.mutableSetValueForKey("locations");
        items.removeObject(value)
    }
}