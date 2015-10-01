//
//  RouteHistory.swift
//  Run
//
//  Created by Steven Li on 8/20/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Darwin

class RouteHistory: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewObject: UITableView!
   
    var number = 1
    let runs = RunManager.runs()

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if RouteDatabase.RouteName.count >= 1 {
        return RouteDatabase.RouteName.count
        }
        else {
            var one = 1
            return one
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> mapCell
        
    {
        
        var identifier:String = "MapReuse"
        let cell:mapCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! mapCell
        var name = RouteDatabase.RouteName[number]
        println(name)
        if RouteDatabase.RouteName.count == 0 {
            cell.routeName.text = "No Routes"
            tableViewObject.rowHeight = 900
            cell.DetailSegue.setTitle("generate route", forState: .Normal)
            
        }
        else{
        var run = runs[indexPath.row]
        cell.routeName.text = "\(run.distance.doubleValue)"
        cell.mapImage.image = RouteDatabase.Images[name!]!
        cell.DetailSegue.setTitle("sfd", forState: .Normal )
        }
        
        number++
        
        
        return cell
        
    }
    
 
}
class mapCell:UITableViewCell {
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var DetailSegue: UIButton!
    
}
extension RouteDatabase{
    
}
extension UserDatabase{
    
}