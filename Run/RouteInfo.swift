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
    var run: Run = mainInstance.Database!

    let managedObjectContext:NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!


    @IBOutlet weak var paceLabel: UILabel!
    
    override func viewDidLoad() {
     println(run.distance.doubleValue)
    }
        //5
        

}
