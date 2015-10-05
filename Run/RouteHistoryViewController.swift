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
import CoreData
class RouteHistory: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewObject: UITableView!
   
    var number = 1
    let managedObjectContext:NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var RunInfoData = [RunInfo]()
   


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        var error: NSError?
        let request = NSFetchRequest(entityName: "RunInfo")
        RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
        var routeCount = RunInfoData.count

        if  routeCount >= 1 {
        return routeCount
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
        var error: NSError?
        let request = NSFetchRequest(entityName: "RunInfo")
        RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
        var routeCount = RunInfoData.count
        var RunInfoForTable = RunInfoData[indexPath.row]
        
        if routeCount == 0 {
            cell.routeName.text = "No Routes"
            tableViewObject.rowHeight = 900
            cell.DetailSegue.setTitle("generate route", forState: .Normal)
        }
        else{
        
        cell.routeName.text = RunInfoForTable.name
        cell.mapImage.image = UIImage(data: RunInfoForTable.image)
        cell.DetailSegue.setTitle("sfd", forState: .Normal )
        }
        
        
        
        return cell
        
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let detailViewController = segue.destinationViewController as? RouteGenerateNavigation {
//        }
//    }
 
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