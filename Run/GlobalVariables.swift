//
//  GlobalVariables.swift
//  Run
//
//  Created by Steven Li on 8/26/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import CoreData

class Main {
    var GlobalDistanceToRun:Double?
    var directionLocOne: CLLocationCoordinate2D
    var directionLocTwo: CLLocationCoordinate2D
    var directionLocThree: CLLocationCoordinate2D
    var directionLocFour: CLLocationCoordinate2D
    var routeInfo: Dictionary<NSObject, AnyObject>!
    var Database: Run?
    
    init(TempDistanceToRun:Double, TempDirectionLocOne: CLLocationCoordinate2D, TempDirectionLocTwo: CLLocationCoordinate2D, TempDirectionLocThree: CLLocationCoordinate2D, TempDirectionLocFour: CLLocationCoordinate2D, TempRouteInfo: Dictionary<NSObject, AnyObject>, TempDatabase: Run!) {
     self.GlobalDistanceToRun = TempDistanceToRun
        self.directionLocOne = TempDirectionLocOne
        self.directionLocTwo = TempDirectionLocTwo
        self.directionLocThree = TempDirectionLocThree
        self.directionLocFour = TempDirectionLocFour
        self.routeInfo = TempRouteInfo
        self.Database = TempDatabase
    }
}
var defaultDirectionLoc = CLLocationCoordinate2DMake(0,0)
var defaultDictionary = [:]
let managedObjectContext:NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
let savedRun: Run = NSEntityDescription.insertNewObjectForEntityForName("RunInfo",
    inManagedObjectContext: managedObjectContext!) as! Run
var run: Run = savedRun
var mainInstance = Main(TempDistanceToRun: 0, TempDirectionLocOne: defaultDirectionLoc, TempDirectionLocTwo: defaultDirectionLoc, TempDirectionLocThree: defaultDirectionLoc, TempDirectionLocFour: defaultDirectionLoc, TempRouteInfo: defaultDictionary as Dictionary<NSObject, AnyObject>, TempDatabase: run)