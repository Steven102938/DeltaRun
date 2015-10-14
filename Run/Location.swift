//
//  Location.swift
//  Run
//
//  Created by Steven Li on 10/3/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var timestamp: NSDate
    @NSManaged var runinfo: RunInfo

}
