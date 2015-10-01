//
//  RouteTracker.swift
//  Run
//
//  Created by Steven Li on 9/23/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import CoreData
import CoreLocation
import HealthKit
let DetailSegueName = "RunDetails"

class RouteTracker: UIViewController, CLLocationManagerDelegate {
    var didFindMyLocation = false
//    var Run = [NSManagedObject]()
    var run: Run!
    var managedObjectContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!


    @IBOutlet weak var MapTracker: GMSMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBAction func StartTrack(sender: AnyObject) {
        startButton.hidden = true
        promptLabel.hidden = true
        
        timeLabel.hidden = false
        distanceLabel.hidden = false
        paceLabel.hidden = false
//        stopButton.hidden = false
        
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        startLocationUpdates()
        
    }
    @IBAction func stopPressed(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Run Stopped", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Discard")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? RouteInfo {
//            detailViewController.run = run
        }
    }

    let locationManager = CLLocationManager()
    var seconds = 0.0
    var distance = 0.0
    lazy var timer = NSTimer()
    var locations = [CLLocation]()
    
    func saveRun() {
        

        
            
        let savedRun: Run = NSEntityDescription.insertNewObjectForEntityForName("RunInfo",
            inManagedObjectContext: managedObjectContext) as! Run
        savedRun.distance = distance
        savedRun.duration = seconds
        savedRun.timestamp = NSDate()
        println(savedRun.distance)
        // 2
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",
                inManagedObjectContext: managedObjectContext) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        
        
        savedRun.locations = NSOrderedSet(array: savedLocations)
        run = savedRun
        mainInstance.Database = run
        }
        // 3
        var error: NSError?
        let success = managedObjectContext.save(&error)
        if !success {
            println("Could not save the run!")
            
        }
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
////
////        for location in locations{
////
////            let entity =  NSEntityDescription.entityForName("RunCoordinates",
////                inManagedObjectContext:
////                managedContext)
////            let coordinateToSave = NSManagedObject(entity: entity!,
////                insertIntoManagedObjectContext:managedContext)
////            
////            coordinateToSave.setValue(location.coordinate.latitude, forKey: "latitude")
////            coordinateToSave.setValue(location.coordinate.longitude, forKey: "longitude")
////
////        }
//        
//        //2
//        let entity =  NSEntityDescription.entityForName("RunInfo",
//            inManagedObjectContext:
//            managedContext)
//        
//        let person = NSManagedObject(entity: entity!,
//            insertIntoManagedObjectContext:managedContext)
//        
//        //3
//        person.setValue(distance, forKey: "distance")
//        person.setValue(seconds, forKey: "duration")
//        person.setValue(NSDate(), forKey: "timestamp")
//        
//        //4
//        var error: NSError?
//        if !managedContext.save(&error) {
//            println("Could not save \(error), \(error?.userInfo)")
//        }  
//        //5
//        Run.append(person)
//        mainInstance.Database = Run
//        println(Run.count)

    }
    func eachSecond(timer: NSTimer) {
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        var secondsRunning = (secondsQuantity.description as NSString!).integerValue
        if secondsRunning <= 60 {
            timeLabel.text = "Time: " + secondsQuantity.description
        }
        else if secondsRunning >= 60{
            timeLabel.text = "\(secondsRunning/60)" + "m" + "\(secondsRunning%60)" + "s"
        }
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = "Pace: " + paceQuantity.description
    }
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var manager: CLLocationManager
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = .Fitness
        self.locationManager.requestAlwaysAuthorization()
        MapTracker.myLocationEnabled = true

        timeLabel.hidden = true
        distanceLabel.hidden = true
        paceLabel.hidden = true
//        stopButton.hidden = true

        
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            MapTracker.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            MapTracker.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
}
// MARK: - MKMapViewDelegate


// MARK: - CLLocationManagerDelegate
extension RouteTracker: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        for location in locations as! [CLLocation] {
            let howRecent = location.timestamp.timeIntervalSinceNow
            var path = GMSMutablePath()
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last)
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    for coordinate in coords{
                    println(coordinate.latitude)
                    path.addCoordinate(coordinate)
                        var polyline = GMSPolyline(path: path)

                    polyline.strokeWidth = 5.0
                    polyline.strokeColor = UIColor.blueColor()
                    polyline.map = MapTracker
                        var camera: GMSCameraPosition = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
                        MapTracker.camera = camera
                        MapTracker.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

                    }
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
}

// MARK: - UIActionSheetDelegate
extension RouteTracker: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //save
        if buttonIndex == 1 {
            saveRun()
            performSegueWithIdentifier(DetailSegueName, sender: nil)
        }
            //discard
        else if buttonIndex == 2 {
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}


