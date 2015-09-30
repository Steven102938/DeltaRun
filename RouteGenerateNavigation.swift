//
//  RouteGenerateNavigation.swift
//  Run
//
//  Created by Steven Li on 9/20/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Darwin
import GoogleMaps
import CoreData

class RouteGenerateNavigation: UIViewController, CLLocationManagerDelegate {
    struct loc {
        static var locValue = CLLocationCoordinate2D()
    }
    @IBOutlet weak var mapLocationPreview: GMSMapView!
    
    
    var managedObjectContext: NSManagedObjectContext?

    let locationManager = CLLocationManager()
    var startLongitude: Double? = nil
    var startLatitude: Double? = nil

    
    

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
            loc.locValue = manager.location.coordinate
            startLatitude = (loc.locValue.latitude)
            startLongitude = (loc.locValue.longitude)
            
            var locationMarkerOne: GMSMarker!
            locationMarkerOne = GMSMarker(position: loc.locValue)
            locationMarkerOne.map = mapLocationPreview
            
                   
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            if  (error != nil) {
                println("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                println("Error with the data")
            }
        })
        
  
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithTarget(loc.locValue, zoom: 11)
        mapLocationPreview.camera = camera
        
        mapLocationPreview.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        
        
        
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error: " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            mapLocationPreview.myLocationEnabled = true
        }
    }
    
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "GMapsDemo", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        alertController.addAction(closeAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            mapLocationPreview.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            mapLocationPreview.settings.myLocationButton = true
            
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var manager: CLLocationManager
        
        
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension UserDatabase{
    
}
extension RouteDatabase{
    
}
