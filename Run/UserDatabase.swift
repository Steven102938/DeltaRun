//
//  UserDatabase.swift
//  Run
//
//  Created by Steven Li on 8/21/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation
import MapKit

struct UserDatabase{
    let Name: String
    let login: String
    let Password: String
    
    
    static func login(login: String, Password: String) -> UserDatabase? {
        if let user = database[login]{
            if user.Password == Password{
                return user
            }
        }
        return nil
    }
    static let database: Dictionary<String, UserDatabase> = {
        var theDatabase = Dictionary<String, UserDatabase>()
        for user in [
            UserDatabase(Name: "Rajat Mittal", login: "RMan", Password: "320"),
            UserDatabase(Name: "Joshua Eberhardt", login: "Genius", Password: "321")
            ]{
                theDatabase[user.login] = user
        }
        return theDatabase
        }()
    
    
}
struct RouteDatabase {
    var coordinateOne: CLLocationCoordinate2D?
    var coordinateTwo: CLLocationCoordinate2D?
    var coordinateThree: CLLocationCoordinate2D?
    var coordinateFour: CLLocationCoordinate2D?
    var routeName: String?
    
//    var defaultCoordinateOne = CLLocationCoordinate2DMake(33, 44)
//    var defaultCoordinateTwo = CLLocationCoordinate2DMake(33, 44)
//    var defaultCoordinateThree = CLLocationCoordinate2DMake(33, 44)
//    var defaultCoordinateFour = CLLocationCoordinate2DMake(33, 44)
//    
    static var CoordinateOne = [String: CLLocationCoordinate2D]()
    static var CoordinateTwo = [String: CLLocationCoordinate2D]()
    static var CoordinateThree = [String: CLLocationCoordinate2D]()
    static var CoordinateFour = [String: CLLocationCoordinate2D]()
    static var RotateValue = [String: Double]()
    static var Images = [String: UIImage]()
    static var RouteName = [Int:String]()

  
//    static let routeDatabase: Dictionary<String, RouteDatabase> = {
//        var theRouteDatabase = Dictionary<String, RouteDatabase>()
//        if theRouteDatabase.count == 0 {
//            
//        }
//        else{
//            var defaultCoordinateOne = CLLocationCoordinate2DMake(33, 44)
//            var defaultCoordinateTwo = CLLocationCoordinate2DMake(33, 44)
//            var defaultCoordinateThree = CLLocationCoordinate2DMake(33, 44)
//            var defaultCoordinateFour = CLLocationCoordinate2DMake(33, 44)
//            
//            for nameOfRoute in [
//                RouteDatabase(coordinateOne: defaultCoordinateOne, coordinateTwo: defaultCoordinateTwo, coordinateThree: defaultCoordinateThree, coordinateFour: defaultCoordinateFour, routeName: "Default")
//                
//                    ]{
//                    theRouteDatabase[nameOfRoute.routeName!] = nameOfRoute
//                        
//                        
//                    
//                }
//            }
//
//        return theRouteDatabase
//        }()
    
//    static func returnCoordinates(routeName: String) -> RouteDatabase? {
//        if let nameOfRoute = routeDatabase[routeName]{
//            return nameOfRoute
//        }
//        return nil
//        
//    }
//    
    
}