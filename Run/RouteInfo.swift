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

    @IBOutlet weak var mapView: GMSMapView!
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
        loadMap()
    }
    func loadMap() {
        var error: NSError?
        var request = NSFetchRequest(entityName: "RunInfo")
        RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
        var previousRun = RunInfoData.removeLast()
        var previousRunLocations = previousRun.locations
        var locationsArray = Array(previousRunLocations) as! [Location]

            if previousRun.locations.count > 0 {
                
                let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: locationsArray)
                for polylines in colorSegments {
                    polylines.map = mapView
                    polylines.strokeColor = polylines.color
                }
                
            } else {
                // No locations were found!
                mapView.hidden = true
                
                UIAlertView(title: "Error",
                    message: "Sorry, this run has no locations saved",
                    delegate:nil,
                    cancelButtonTitle: "OK").show()
            }
        }
    
    
}
        //5
        

