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

class DirectionsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var DirectionsMapView: GMSMapView!
    
    @IBOutlet weak var DirectionsDistance: UILabel!
   
    @IBOutlet weak var DirectionsText: UILabel!
    
    struct global {
        static var directions: Dictionary<NSObject, AnyObject>! = mainInstance.routeInfo
        static var directionsLocOne: CLLocationCoordinate2D = mainInstance.directionLocOne
        static var directionsLocTwo: CLLocationCoordinate2D = mainInstance.directionLocTwo
        static var directionsLocThree: CLLocationCoordinate2D = mainInstance.directionLocThree
        static var directionsLocFour: CLLocationCoordinate2D = mainInstance.directionLocFour
        static var overviewPolyline: Dictionary<NSObject, AnyObject>!
    }
    
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var waypointOne: GMSMarker!
    var waypointTwo: GMSMarker!
    var routePolyline: GMSPolyline!
    
    override func viewDidLoad() {
        println(global.directions)
        
        
        
        
        global.overviewPolyline = global.directions["overview_polyline"] as! Dictionary<NSObject, AnyObject>
        
        let legs = global.directions["legs"] as! Array<Dictionary<NSObject, AnyObject>>
        
        let startLocationDictionary = legs[0]["start_location"] as! Dictionary<NSObject, AnyObject>
        
        
        let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
        
        configureMapAndMarkersForRoute()
        drawRoute()
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

