//
//  MapOverviewViewController.swift
//  Run
//
//  Created by Steven Li on 8/24/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import Darwin

class MapOverviewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    @IBOutlet weak var mapOverView: GMSMapView!
    
    @IBAction func SaveRoute(sender: AnyObject) {
        SaveRoute!.routeName = "pokemon"
        SaveRoute!.coordinateOne = loc.locValueToSave
        SaveRoute!.coordinateTwo = loc.locValueOne
        SaveRoute!.coordinateThree = loc.locValueTwo
        SaveRoute!.coordinateFour = loc.locValueThree
        // append, add new dictionary
        RouteDatabase(coordinateOne: loc.locValueToSave, coordinateTwo: loc.locValueOne, coordinateThree: loc.locValueTwo, coordinateFour: loc.locValueThree, routeName: "pokemon")
    }
    
    
    struct loc {
        
        static var locValue = CLLocationCoordinate2D()
        static var locValueOne = CLLocationCoordinate2D()
        static var locValueTwo = CLLocationCoordinate2D()
        static var locValueThree = CLLocationCoordinate2D()
        static var locValueToSave = CLLocationCoordinate2D()
        static var randomRotate: Double = Double(arc4random_uniform(90))
        static var routeDistance: Double?
        static var CalculateRouteDistance:Double = mainInstance.GlobalDistanceToRun!
        static var selectedRoute: Dictionary<NSObject, AnyObject>!
        
    }
    
    @IBAction func Segue(sender: AnyObject) {
        mainInstance.directionLocOne = loc.locValue
        mainInstance.directionLocTwo = loc.locValueOne
        mainInstance.directionLocThree = loc.locValueTwo
        mainInstance.directionLocFour = loc.locValueThree
        mainInstance.routeInfo = loc.selectedRoute
    }
   
    @IBAction func regnerateRoute(sender: AnyObject) -> Void {
        loc.randomRotate = Double(arc4random_uniform(360))
        loc.selectedRoute = nil
        self.locationManager.startUpdatingLocation()
        mapOverView.clear()
        
    }
    
    
    
    
    let locationManager = CLLocationManager()
    var startLongitude: Double? = nil
    var startLatitude: Double? = nil
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var didFindMyLocation = false
    var routePolyline: GMSPolyline!
    
    
    var Beginning:MKMapItem = MKMapItem()
    var destinationOne:MKMapItem = MKMapItem()
    var SaveRoute: RouteDatabase?
    
    
    var RouteDistanceCoordinateDividedBy4 = ( mainInstance.GlobalDistanceToRun! / 276)
    
  
    func getDirections(waypoints: Array<String>!, travelMode: AnyObject!){
                var maxLoop = 0
                var directionsURLString = baseURLDirections + "origin=" + "(\(loc.locValue.latitude), \(loc.locValue.longitude))" + "&destination=" + "(\(loc.locValue.latitude), \(loc.locValue.longitude))" + "&waypoints=" + "(\(loc.locValueOne.latitude), \(loc.locValueOne.longitude))" + "|" + "(\(loc.locValueTwo.latitude), \(loc.locValueTwo.longitude))" + "|" + "(\(loc.locValueThree.latitude), \(loc.locValueThree.longitude))" + "&mode=walking" + "&avoid=highways" + "?avoid=ferries"
        
                println("\(directionsURLString)")
        println("\(loc.randomRotate)")
                directionsURLString = directionsURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                let directionsURL = NSURL(string: directionsURLString)
        
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let directionsData = NSData(contentsOfURL: directionsURL!)
            println("dispatching")
            
                    var error: NSError?
                    
                    var dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(directionsData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! Dictionary<NSObject, AnyObject>
                    
                    if (error != nil) {
                        println(error)
                        
                    }
                    else {

                            loc.selectedRoute = (dictionary["routes"] as! Array<Dictionary<NSObject, AnyObject>>)[0]
                        
                        
                            self.overviewPolyline = loc.selectedRoute["overview_polyline"] as! Dictionary<NSObject, AnyObject>
                            
                            let legs = loc.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<NSObject, AnyObject>
                            self.originCoordinate = loc.locValue
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
                            self.destinationCoordinate = loc.locValueThree
                            
                            println("set routes")
                       
                            self.calculateTotalDistanceAndDuration()
                            
                            self.configureMapAndMarkersForRoute()
                            self.drawRoute()
                            self.displayRouteInfo()
                        println(loc.selectedRoute)
                  
                      
                        
                        if loc.routeDistance! * 0.621371 >= loc.CalculateRouteDistance + loc.CalculateRouteDistance/2 || loc.routeDistance <= loc.CalculateRouteDistance - loc.CalculateRouteDistance/2 {
                            
                            loc.randomRotate = Double(arc4random_uniform(90))
                            loc.selectedRoute = nil
                            self.locationManager.startUpdatingLocation()
                            self.mapOverView.clear()
                            maxLoop++
                            if maxLoop >= 20 {
                                println("error")
                                
                            }
                        }
                       
                    }
                })
        
        
    
        
    }
    
    
    func configureMapAndMarkersForRoute(){
    originMarker = GMSMarker(position: loc.locValue)
    originMarker.map = self.mapOverView
    originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
    originMarker.title = "start"
    
    destinationMarker = GMSMarker(position: loc.locValueThree)
    destinationMarker.map = self.mapOverView
    destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
    destinationMarker.title = "end"
        
        destinationMarker = GMSMarker(position: loc.locValueTwo)
        destinationMarker.map = self.mapOverView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = "locvaluetwo"

        
        destinationMarker = GMSMarker(position: loc.locValueOne)
        destinationMarker.map = self.mapOverView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = "locValueOne"

    }
    
    func drawRoute() {
        let route = self.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = mapOverView
    }
    
    func displayRouteInfo() {
       println("\(self.totalDistance) + \n + \(self.totalDuration)")
    }
   
    func calculateTotalDistanceAndDuration() {
        let legs = loc.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
        }
        
        
        loc.routeDistance = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(loc.routeDistance) Km"
        
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
    }
    
    
//    func showRoute(response: MKDirectionsResponse) {
//        for route in response.routes as! [MKRoute] {
//            mapOverView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
//            var Directions: [String] = []
//            
//            for step in route.steps{
//                Directions.append(step.instructions)}
//            var filteredArray = Directions.filter({ $0 != "The destination is on your right" })
//            var filteredArrayOne = filteredArray.filter({ $0 != "The destination is on your left" })
//            println(filteredArrayOne)
//            for step in route.steps{
//                println(step.distance)}
//        }
//    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
       
        var degreeToRotate: Double = loc.randomRotate
        //check 79 82 31
        let randomDegreeToRotate:Double = degreeToRotate * (M_PI/180)
        
        if degreeToRotate <= 90 {
            
        var degreeminus90 = (Double(90 - degreeToRotate)) * (M_PI/180)
        var sinOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (sin(randomDegreeToRotate)))
        var cosOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (cos(randomDegreeToRotate)))
        
        var sinOfDistanceOne =  (RouteDistanceCoordinateDividedBy4 * (sin(degreeminus90)))
        var cosOfDistanceOne = (RouteDistanceCoordinateDividedBy4 * (cos(degreeminus90)))
        println("\(sinOfDistanceOne)" + "\(cosOfDistanceOne)")
        
        
        loc.locValue = manager.location.coordinate
        startLatitude = (loc.locValue.latitude)
        startLongitude = (loc.locValue.longitude)
        var locationMarkerOne: GMSMarker!
        locationMarkerOne = GMSMarker(position: loc.locValue)
        locationMarkerOne.map = mapOverView
        
        loc.locValueOne = CLLocationCoordinate2DMake(((loc.locValue.latitude) +  sinOfDistanceOne),((loc.locValue.longitude) + cosOfDistanceOne))
        println("locations = \(loc.locValueOne.latitude) \(loc.locValueOne.longitude)")
        println("\(loc.CalculateRouteDistance)")
        var locationMarkerTwo: GMSMarker!
        locationMarkerTwo = GMSMarker(position: loc.locValueOne)
        locationMarkerTwo.map = mapOverView
        
        loc.locValueTwo = CLLocationCoordinate2DMake( ((loc.locValueOne.latitude) - sinOfDistanceThree),((loc.locValueOne.longitude) + cosOfDistanceThree))
        println("locations = \(loc.locValueTwo.latitude) \(loc.locValueTwo.longitude)")
        println("\(loc.CalculateRouteDistance)")
        var locationMarkerThree: GMSMarker!
        locationMarkerThree = GMSMarker(position: loc.locValueTwo)
        locationMarkerThree.map = mapOverView
        
        loc.locValueThree = CLLocationCoordinate2DMake((((loc.locValue.latitude)) - sinOfDistanceThree),((loc.locValue.longitude) + cosOfDistanceThree))
        println("locations = \(loc.locValueThree.latitude) \(loc.locValueThree.longitude)")
        println("\(loc.CalculateRouteDistance)")
        var locationMarkerFour: GMSMarker!
        locationMarkerFour = GMSMarker(position: loc.locValueThree)
        locationMarkerFour.map = mapOverView
        }
        else if (degreeToRotate <= 180 && degreeToRotate > 90)  {
            var degreeminus90 = Double(degreeToRotate - 90) * (M_PI/180)
            var oneEightyMinusDegree = Double(180 - degreeToRotate) * (M_PI/180)
            
            var sinOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (sin(oneEightyMinusDegree)))
            var cosOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (cos(oneEightyMinusDegree)))
            
            var sinOfDistanceOne =  (RouteDistanceCoordinateDividedBy4 * (sin(degreeminus90)))
            var cosOfDistanceOne = (RouteDistanceCoordinateDividedBy4 * (cos(degreeminus90)))
            println("\(sinOfDistanceOne)" + "\(cosOfDistanceOne)")
            
            
            loc.locValue = manager.location.coordinate
            startLatitude = (loc.locValue.latitude)
            startLongitude = (loc.locValue.longitude)
            var locationMarkerOne: GMSMarker!
            locationMarkerOne = GMSMarker(position: loc.locValue)
            locationMarkerOne.map = mapOverView
            
            loc.locValueOne = CLLocationCoordinate2DMake(((loc.locValue.latitude) - sinOfDistanceOne),((loc.locValue.longitude) + cosOfDistanceOne))
            println("locations = \(loc.locValueOne.latitude) \(loc.locValueOne.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerTwo: GMSMarker!
            locationMarkerTwo = GMSMarker(position: loc.locValueOne)
            locationMarkerTwo.map = mapOverView
            
            loc.locValueTwo = CLLocationCoordinate2DMake( ((loc.locValueOne.latitude) - sinOfDistanceThree),((loc.locValueOne.longitude) - cosOfDistanceThree))
            println("locations = \(loc.locValueTwo.latitude) \(loc.locValueTwo.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerThree: GMSMarker!
            locationMarkerThree = GMSMarker(position: loc.locValueTwo)
            locationMarkerThree.map = mapOverView
            
            loc.locValueThree = CLLocationCoordinate2DMake((((loc.locValue.latitude)) - sinOfDistanceThree),((loc.locValue.longitude) - cosOfDistanceThree))
            println("locations = \(loc.locValueThree.latitude) \(loc.locValueThree.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerFour: GMSMarker!
            locationMarkerFour = GMSMarker(position: loc.locValueThree)
            locationMarkerFour.map = mapOverView
        }
        
        else if (degreeToRotate <= 270 && degreeToRotate > 180)  {
            var degreeminus270 = Double(270 - degreeToRotate) * (M_PI/180)
            var sinOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (sin(randomDegreeToRotate)))
            var cosOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (cos(randomDegreeToRotate)))
            
            var sinOfDistanceOne =  (RouteDistanceCoordinateDividedBy4 * (sin(degreeminus270)))
            var cosOfDistanceOne = (RouteDistanceCoordinateDividedBy4 * (cos(degreeminus270)))
            println("\(sinOfDistanceOne)" + "\(cosOfDistanceOne)")
            
            
            loc.locValue = manager.location.coordinate
            startLatitude = (loc.locValue.latitude)
            startLongitude = (loc.locValue.longitude)
            var locationMarkerOne: GMSMarker!
            locationMarkerOne = GMSMarker(position: loc.locValue)
            locationMarkerOne.map = mapOverView
            
            loc.locValueOne = CLLocationCoordinate2DMake(((loc.locValue.latitude) - sinOfDistanceOne),((loc.locValue.longitude) - cosOfDistanceOne))
            println("locations = \(loc.locValueOne.latitude) \(loc.locValueOne.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerTwo: GMSMarker!
            locationMarkerTwo = GMSMarker(position: loc.locValueOne)
            locationMarkerTwo.map = mapOverView
            
            loc.locValueTwo = CLLocationCoordinate2DMake( ((loc.locValueOne.latitude) - sinOfDistanceThree),((loc.locValueOne.longitude) + cosOfDistanceThree))
            println("locations = \(loc.locValueTwo.latitude) \(loc.locValueTwo.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerThree: GMSMarker!
            locationMarkerThree = GMSMarker(position: loc.locValueTwo)
            locationMarkerThree.map = mapOverView
            
            loc.locValueThree = CLLocationCoordinate2DMake((((loc.locValue.latitude)) - sinOfDistanceThree),((loc.locValue.longitude) + cosOfDistanceThree))
            println("locations = \(loc.locValueThree.latitude) \(loc.locValueThree.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerFour: GMSMarker!
            locationMarkerFour = GMSMarker(position: loc.locValueThree)
            locationMarkerFour.map = mapOverView
        }
        else if (degreeToRotate <= 360 && degreeToRotate > 270)  {
            var three60minusdegree = Double(360 - degreeToRotate) * (M_PI/180)
            var degreeminus270 = Double(degreeToRotate - 270) * (M_PI/180)
            var sinOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (sin(three60minusdegree)))
            var cosOfDistanceThree = (RouteDistanceCoordinateDividedBy4 * (cos(three60minusdegree)))
            
            var sinOfDistanceOne =  (RouteDistanceCoordinateDividedBy4 * (sin(degreeminus270)))
            var cosOfDistanceOne = (RouteDistanceCoordinateDividedBy4 * (cos(degreeminus270)))
            println("\(sinOfDistanceOne)" + "\(cosOfDistanceOne)")
            
            
            loc.locValue = manager.location.coordinate
            startLatitude = (loc.locValue.latitude)
            startLongitude = (loc.locValue.longitude)
            var locationMarkerOne: GMSMarker!
            locationMarkerOne = GMSMarker(position: loc.locValue)
            locationMarkerOne.map = mapOverView
            
            loc.locValueOne = CLLocationCoordinate2DMake(((loc.locValue.latitude) +  sinOfDistanceOne),((loc.locValue.longitude) - cosOfDistanceOne))
            println("locations = \(loc.locValueOne.latitude) \(loc.locValueOne.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerTwo: GMSMarker!
            locationMarkerTwo = GMSMarker(position: loc.locValueOne)
            locationMarkerTwo.map = mapOverView
            
            loc.locValueTwo = CLLocationCoordinate2DMake( ((loc.locValueOne.latitude) + sinOfDistanceThree),((loc.locValueOne.longitude) + cosOfDistanceThree))
            println("locations = \(loc.locValueTwo.latitude) \(loc.locValueTwo.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerThree: GMSMarker!
            locationMarkerThree = GMSMarker(position: loc.locValueTwo)
            locationMarkerThree.map = mapOverView
            
            loc.locValueThree = CLLocationCoordinate2DMake((((loc.locValue.latitude)) + sinOfDistanceThree),((loc.locValue.longitude) + cosOfDistanceThree))
            println("locations = \(loc.locValueThree.latitude) \(loc.locValueThree.longitude)")
            println("\(loc.CalculateRouteDistance)")
            var locationMarkerFour: GMSMarker!
            locationMarkerFour = GMSMarker(position: loc.locValueThree)
            locationMarkerFour.map = mapOverView
        }

        
//        loc.locValueToSave = CLLocationCoordinate2DMake( (loc.locValue.latitude),(loc.locValue.longitude))
        
//        var StartLocation = MKPointAnnotation()
//        StartLocation.coordinate = loc.locValue
//        //         mapOverView.addAnnotation(StartLocation)
//        
//        var LocationOne = MKPointAnnotation()
//        LocationOne.coordinate = loc.locValueOne
//        //         mapOverView.addAnnotation(LocationOne)
//        
//        var LocationTwo = MKPointAnnotation()
//        LocationTwo.coordinate = loc.locValueTwo
//        //         mapOverView.addAnnotation(LocationTwo)
//        
//        var LocationThree = MKPointAnnotation()
//        LocationThree.coordinate = loc.locValueThree
//        //        mapOverView.addAnnotation(LocationThree)
//       
//        
       // mapOverView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(loc.locValue.latitude, loc.locValue.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        
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
        
        let BeginningPlaceMark = MKPlacemark(coordinate: loc.locValue, addressDictionary: nil)
        var Beginning = MKMapItem(placemark: BeginningPlaceMark)
        
        let DestinationOnePlaceMark = MKPlacemark(coordinate: loc.locValueOne, addressDictionary: nil)
        var destinationOne = MKMapItem(placemark: DestinationOnePlaceMark)
        
        let DestinationTwoPlaceMark = MKPlacemark(coordinate: loc.locValueTwo, addressDictionary: nil)
        var destinationTwo = MKMapItem(placemark: DestinationTwoPlaceMark)
        
        let DestinationThreePlaceMark = MKPlacemark(coordinate: loc.locValueThree, addressDictionary: nil)
        var destinationThree = MKMapItem(placemark: DestinationThreePlaceMark)
        
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithTarget(loc.locValue, zoom: 10)
        mapOverView.camera = camera
       
        mapOverView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        self.getDirections(nil, travelMode: nil)

    
        //        let requestOne = MKDirectionsRequest()
        //        requestOne.setSource(Beginning)
        //        requestOne.setDestination(destinationOne)
        //        requestOne.requestsAlternateRoutes = false
        //       requestOne.transportType = MKDirectionsTransportType.Automobile
        //
        //        let requestTwo = MKDirectionsRequest()
        //        requestTwo.setSource(destinationOne)
        //        requestTwo.setDestination(destinationTwo)
        //        requestTwo.requestsAlternateRoutes = false
        //       requestTwo.transportType = MKDirectionsTransportType.Automobile
        //
        //        let requestThree = MKDirectionsRequest()
        //        requestThree.setSource(destinationTwo)
        //        requestThree.setDestination(destinationThree)
        //        requestThree.requestsAlternateRoutes = false
        //        requestThree.transportType = MKDirectionsTransportType.Automobile
        //
        //        let requestFour = MKDirectionsRequest()
        //        requestFour.setSource(destinationThree)
        //        requestFour.setDestination(Beginning)
        //        requestFour.requestsAlternateRoutes = false
        //        requestFour.transportType = MKDirectionsTransportType.Automobile
        //
        //        let directionsOne = MKDirections(request: requestOne)
        //
        //        directionsOne.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
        //            if error != nil {
        //                println()
        //            }
        //            else{
        //                self.showRoute(response)
        //            }
        //            })
        //
        //        let directionsTwo = MKDirections(request: requestTwo)
        //
        //        directionsTwo.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
        //            if error != nil {
        //                println()
        //            }
        //            else{
        //                self.showRoute(response)
        //            }
        //        })
        //
        //        let directionsThree = MKDirections(request: requestThree)
        //
        //        directionsThree.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
        //            if error != nil {
        //                println()
        //            }
        //            else{
        //                self.showRoute(response)
        //            }
        //        })
        //
        //        let directionsFour = MKDirections(request: requestFour)
        //
        //        directionsFour.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
        //            if error != nil {
        //                println()
        //            }
        //            else{
        //                self.showRoute(response)
        //
        //            }
        //
        //        })
        //
        
        
        //        var urlone: String = "http://maps.googleapis.com/maps/api/directions/xml?"
        //            + "origin=\(locValue.latitude),\(locValue.longitude)" + "&destination=\(locValueThree.latitude),\(locValueThree.longitude)" + "&waypoints=\(locValueOne.latitude),\(locValueOne.longitude)" + "|\(locValueTwo.latitude),\(locValueTwo.longitude)&key=AIzaSyDmmaydVxcfknPDiUGCFo5lVkyx9Ue1GZg"
        //
        //        var urlString: String = urlone
        //        var directionsURL = NSURL(string: urlString)!
        //        var request = NSURLRequest(URL: directionsURL)
        //        var queue: NSOperationQueue = NSOperationQueue()
        //
        //        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response: NSURLResponse!,responseData: NSData!,error: NSError!) -> Void in
        //
        //        if !(error != nil) {
        //
        //                let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")
        //                let data: AnyObject? = NSData.dataWithContentsOfMappedFile(path!)
        //
        //                let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data! as! NSData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        //
        //
        //            // JSONObjectWithData(request.responseData(), options: NSJSONReadingMutableContainers, error: &error)
        //            var pathLine: GMSPath? = GMSPath.pathFromEncodedPath(json["routes"][0]["overview_polyline"]["points"])
        //            var singleLine: GMSPolyline = GMSPolyline.polylineWithPath(path)
        //            singleLine.strokeWidth = 7
        //            singleLine.strokeColor = UIColor.greenColor()
        //            singleLine.map = self.mapOverView
        //        }
        //        else {
        //            NSLog("facebook.com/truqchal%@", request.error())
        //        }
        //
        //        }
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0
            return renderer
            
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
            mapOverView.myLocationEnabled = true
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
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            mapOverView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            mapOverView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
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
