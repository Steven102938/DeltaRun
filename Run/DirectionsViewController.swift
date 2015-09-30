//
//  DirectionsViewController.swift
//  Run
//
//  Created by Steven Li on 9/9/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import Darwin

class DirectionsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var DirectionsMapView: GMSMapView!
    
    @IBOutlet weak var DirectionsDistance: UILabel!
   
    @IBOutlet weak var DirectionsText: UILabel!
    
    @IBOutlet weak var DirectionHeading: UILabel!
    
    @IBAction func NextStep(sender: AnyObject) {
        global.directionsNumber++
        displayDirections()
    }
    struct global {
        static var directions: Dictionary<NSObject, AnyObject>! = mainInstance.routeInfo
        static var directionsLocOne: CLLocationCoordinate2D = mainInstance.directionLocOne
        static var directionsLocTwo: CLLocationCoordinate2D = mainInstance.directionLocTwo
        static var directionsLocThree: CLLocationCoordinate2D = mainInstance.directionLocThree
        static var directionsLocFour: CLLocationCoordinate2D = mainInstance.directionLocFour
        static var overviewPolyline: Dictionary<NSObject, AnyObject>!
        static var legs: Array<Dictionary<NSObject, AnyObject>>!
        static var steps: Array<Dictionary<NSObject, AnyObject>>!
        static var location = CLLocationCoordinate2D()
        static var displayedRouteDistanceInt = 0
        static var directionsNumber = 1
        static var streetDirections: Dictionary<Int, String> = [:]
        static var streetDistanceInt: Dictionary<Int, Int> = [:]
        static var endStreetLongitude: Dictionary<Int, Double> = [:]
        static var endStreetLatitude: Dictionary<Int, Double> = [:]
        static var locationLatitude: Double?
        static var locationLongitude: Double?
        static var endStepLatitude: Double?
        static var endStepLongitude: Double?
    }
    
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var waypointOne: GMSMarker!
    var waypointTwo: GMSMarker!
    var routePolyline: GMSPolyline!
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var manager: CLLocationManager
        println(global.directions)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        global.legs = global.directions["legs"] as! Array<Dictionary<NSObject, AnyObject>>
        for leg in global.legs {
    
            global.steps = leg["steps"] as! Array<Dictionary<NSObject, AnyObject>>
        }
        global.overviewPolyline = global.directions["overview_polyline"] as! Dictionary<NSObject, AnyObject>
    
        configureMapAndMarkersForRoute()
        drawRoute()
        calculateDisplayDirections()
        displayDirections()
        let startLocationDictionary = (global.legs)[0]["start_location"] as! Dictionary<NSObject, AnyObject>
        
        let endLocationDictionary = global.legs[global.legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
    }
    
    func configureMapAndMarkersForRoute(){
        originMarker = GMSMarker(position: global.directionsLocOne)
        originMarker.map = self.DirectionsMapView
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        originMarker.title = "start"
        
        destinationMarker = GMSMarker(position: global.directionsLocFour)
        destinationMarker.map = self.DirectionsMapView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = "end"
        
        destinationMarker = GMSMarker(position: global.directionsLocTwo)
        destinationMarker.map = self.DirectionsMapView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = "locvaluetwo"
        
        
        destinationMarker = GMSMarker(position: global.directionsLocThree)
        destinationMarker.map = self.DirectionsMapView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = "locValueOne"
        
    }
    
    func drawRoute() {
        let route = global.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = DirectionsMapView
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        global.location = manager.location.coordinate
        
        
        var endLongitude:Double = 0
        var endLatitude:Double = 0
      var stepNumber = 0
        var cameraDegree:CLLocationDirection = 0
        var coordinateOne:Double = 0
        var coordinateTwo:Double = 0
        DirectionsMapView.settings.myLocationButton = true
        DirectionsMapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        for step in global.steps {
            endLatitude = (step["end_location"] as! Dictionary<NSObject, AnyObject>)["lat"] as! Double
            endLongitude = (step["end_location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! Double
        }
        global.endStreetLongitude[++stepNumber] = endLongitude
        global.endStreetLatitude[stepNumber] = endLatitude
        global.endStepLatitude = global.endStreetLatitude[global.directionsNumber]
        global.endStepLongitude = global.endStreetLongitude[global.directionsNumber]
        global.locationLatitude = (global.location.latitude)
        global.locationLongitude = (global.location.longitude)
        
//        //bearingValue = ((global.locationLatitude! - global.endStepLatitude!)/(global.locationLongitude! - global.endStepLongitude!))
//        coordinateOne = abs(global.locationLongitude! - global.endStepLongitude!)
//        coordinateTwo = log((tan(global.endStepLatitude!/2 + M_PI/4))/(tan(global.locationLatitude!/2 + M_PI/4)))
//        cameraDegree = atan2(coordinateOne, coordinateTwo)
//        
//        println(cameraDegree)
//        println(global.locationLatitude!)
//        println(global.locationLongitude!)
//        println(global.endStepLatitude!)
//        println(global.endStepLongitude!)
        var camera: GMSCameraPosition = GMSCameraPosition.cameraWithTarget(global.location, zoom: 17, bearing: 30, viewingAngle: 40)
        DirectionsMapView.camera = camera
//        
//         var distancetostepOne:Double = 2 * asin(sqrt((sin((global.locationLatitude! - global.endStepLatitude!)/2)) * (sin((global.locationLatitude! - global.endStepLatitude!)/2))) + (cos(global.locationLatitude!) * cos(global.endStepLatitude!) * (sin((global.locationLongitude! - global.endStepLongitude!)/2) * sin((global.locationLongitude! - global.endStepLongitude!)/2))))
//        
       
//        println(distancetostepOne)
    }
 
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            DirectionsMapView.myLocationEnabled = true
        }
    }
    func calculateDisplayDirections () {
        
        var stepNumber = 0
        var routeInstructions = "pokemon"
        var routeDistance = "0"
        var routeDistanceInt = 0
       

        for step in global.steps {
            routeDistanceInt = (step["distance"] as! Dictionary<NSObject, AnyObject>)["value"] as! Int
         routeInstructions = step["html_instructions"] as! String
            
            
            global.streetDirections[++stepNumber] = "\(routeInstructions)"
            global.streetDistanceInt[stepNumber] = routeDistanceInt

            println(step)

        }
      
     
    }
    func displayDirections () {
        var displayedRouteText = " "
        var displayedManeuver = " "
        var displayedRouteDistance = " "
        var displayedRouteDisanceIntKm = 0
        
        displayedRouteText = global.streetDirections[global.directionsNumber]!
        global.displayedRouteDistanceInt = global.streetDistanceInt[global.directionsNumber]!
        
        if global.displayedRouteDistanceInt < 1000{
            displayedRouteDistance = "\(global.displayedRouteDistanceInt)" + "m"
        }
        else if global.displayedRouteDistanceInt >= 1000 {
            var roundedDistance: Double = (round(Double(global.displayedRouteDistanceInt/100)))/10
            displayedRouteDistance = "\(roundedDistance)" + "km"
        }
        
        
        var DirectionsTextSwift = NSAttributedString(
            data: displayedRouteText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil)
        
        
        if DirectionsTextSwift?.string.rangeOfString("Turn right") != nil{
            displayedManeuver = "↱"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Turn left") != nil{
            displayedManeuver = "↰"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Slight left") != nil{
            displayedManeuver = "↖︎"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Slight right") != nil{
            displayedManeuver = "↗︎"
        }
        else if DirectionsTextSwift?.string.rangeOfString("At the roundabout, take the 3rd exit") != nil{
            displayedManeuver = "↰"
        }
        else if DirectionsTextSwift?.string.rangeOfString("At the roundabout, take the 2nd exit") != nil{
            displayedManeuver = "↑"
        }
        else if DirectionsTextSwift?.string.rangeOfString("At the roundabout, take the 1st exit") != nil{
            displayedManeuver = "↱"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Head north") != nil{
            displayedManeuver = "N"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Head west") != nil{
            displayedManeuver = "W"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Head east") != nil{
            displayedManeuver = "E"
        }
        else if DirectionsTextSwift?.string.rangeOfString("Head south") != nil{
            displayedManeuver = "S"
        }
        else if DirectionsTextSwift?.string.rangeOfString("crosswalk") != nil{
            displayedManeuver = "⥣"
        }
        
        
        
        DirectionsText.text = DirectionsTextSwift?.string
        DirectionsDistance.text = displayedRouteDistance
        DirectionHeading.text = displayedManeuver
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
        
            DirectionsMapView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
        else {
            println("no location authorization")
        }
    }
    
//
//    func displayRouteInfo() {
//        println("\(self.totalDistance) + \n + \(self.totalDuration)")
//    }
//    
//    func calculateTotalDistanceAndDuration() {
//        let legs = loc.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
//        
//        totalDistanceInMeters = 0
//        totalDurationInSeconds = 0
//        
//        for leg in legs {
//            totalDistanceInMeters += (leg["distance"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
//            totalDurationInSeconds += (leg["duration"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
//        }
//        
//        
//        loc.routeDistance = Double(totalDistanceInMeters / 1000)
//        totalDistance = "Total Distance: \(loc.routeDistance) Km"
//        
//        
//        let mins = totalDurationInSeconds / 60
//        let hours = mins / 60
//        let days = hours / 24
//        let remainingHours = hours % 24
//        let remainingMins = mins % 60
//        let remainingSecs = totalDurationInSeconds % 60
//        
//        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
//    }

}

