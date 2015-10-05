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

    let managedObjectContext:NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var RunInfoData = [RunInfo]()

    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        var error: NSError?
        let request = NSFetchRequest(entityName: "RunInfo")
        RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
        var number = RunInfoData.count
        let currentdata = RunInfoData.removeLast()
        var distance = currentdata.distance as Double
        var seconds = currentdata.duration as Double
        println(RunInfoData.count)
        if distance == 0 {
            paceLabel.text = "Pace:0"
        }
        else{
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = "Pace: " + paceQuantity.description
        }
        
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        var secondsRunning = (secondsQuantity.description as NSString!).integerValue
        if secondsRunning <= 60 {
            timeLabel.text = "Time: " + secondsQuantity.description
        }
        else if secondsRunning >= 60{
            timeLabel.text = "\(secondsRunning/60)" + "m" + "\(secondsRunning%60)" + "s"
        }
        
        
    }
    
}
        //5
        

