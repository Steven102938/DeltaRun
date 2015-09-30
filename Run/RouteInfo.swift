//
//  RouteInfo.swift
//  Run
//
//  Created by Steven Li on 9/25/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import CoreData
import CoreLocation
import HealthKit


class RouteInfo: UIViewController {
    var Database = [NSManagedObject]()
    @IBOutlet weak var paceLabel: UILabel!
    
    override func viewDidLoad() {
    Database = mainInstance.Database
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("RunInfo",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        println(Database.count)
        var pokemon = 1
        let currentRun = Database[pokemon]
    println(currentRun.valueForKey("distance") as? String)
    }
        //5
        

}
