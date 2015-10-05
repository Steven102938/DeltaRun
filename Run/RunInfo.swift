//
//  RunInfo.swift
//  Run
//
//  Created by Steven Li on 10/4/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import CoreData

class RunInfo: NSManagedObject {

    @NSManaged var distance: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var timestamp: NSDate
    @NSManaged var name: String
    @NSManaged var image: NSData
    @NSManaged var location: Location

}
