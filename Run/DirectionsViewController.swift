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
    @IBOutlet weak var TextRouteDirections: UILabel!
    @IBOutlet weak var NumberRouteDirections: UILabel!
    @IBOutlet weak var DirectionsMapView: GMSMapView!
   
    
    struct global {
        static var directions: Dictionary<NSObject, AnyObject>! = mainInstance.routeInfo
        
    }

    
}

