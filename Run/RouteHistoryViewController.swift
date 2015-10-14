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
    var managedObjectContext:NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var RunInfoData = [RunInfo]()
    var deleteRouteIndexPath: NSIndexPath? = nil
    
    override func viewDidAppear(animated: Bool) {
        tableViewObject.reloadData()
        tableViewObject.reloadInputViews()
    }
 func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            var error: NSError?
            var request = NSFetchRequest(entityName: "RunInfo")
            RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext!
            context.deleteObject(RunInfoData[indexPath.row] as NSManagedObject)
            RunInfoData.removeAtIndex(indexPath.row)
            context.save(nil)
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            self.tableViewObject.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         
        default:
            return
            
        }
    }
  
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var error: NSError?
        var request = NSFetchRequest(entityName: "RunInfo")
        RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
        var routeCount = RunInfoData.count

        return routeCount
    
    }
   
    
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> mapCell
        {
        var identifier:String = "MapReuse"
        var cell:mapCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! mapCell
        var error: NSError?
        var request = NSFetchRequest(entityName: "RunInfo")
        RunInfoData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [RunInfo]
        var routeCount = RunInfoData.count
        
        
          
            var RunInfoForTable = RunInfoData[indexPath.row]
            
            cell.routeName.text = RunInfoForTable.name
            cell.mapImage.image = UIImage(data: RunInfoForTable.image)
            cell.DetailSegue.setTitle("sfd", forState: .Normal )

            
        
 
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
extension RouteDatabase{
    
}
extension UserDatabase{
    
}