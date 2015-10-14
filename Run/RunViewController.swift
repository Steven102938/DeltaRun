//
//  ViewController.swift
//  Run
//
//  Created by Steven Li on 8/20/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import UIKit
import Foundation


class RunViewController: UIViewController, UITextFieldDelegate {
    
    
    
    struct OutletVariables{
        static var RouteDistance: Double? = mainInstance.GlobalDistanceToRun {
            didSet{
                mainInstance.GlobalDistanceToRun = RouteDistance
            }
        }
    }
  
    
    @IBOutlet weak var DistanceToRun: UITextField!
    
    @IBOutlet weak var HoursRunning: UITextField!
    
    @IBOutlet weak var MinutesRunning: UITextField!
    
    @IBOutlet weak var MinutesMilePace: UITextField!
    
    @IBOutlet weak var SecondsMilePace: UITextField!

   
    @IBAction func CalculateRoute(sender: UIButton?) {
    
    if DistanceToRun.text! != ""{
        OutletVariables.RouteDistance = ((DistanceToRun.text) as NSString).doubleValue
        println(OutletVariables.RouteDistance!)
        
        }
        
    else{
        var HoursToRun = ((HoursRunning.text!) as NSString).doubleValue
        var MinutesToRun = ((MinutesRunning.text) as NSString).doubleValue
        var MinutesMile = ((MinutesMilePace.text) as NSString).doubleValue
        var SecondsMile = ((SecondsMilePace.text!) as NSString).doubleValue
        
         var HoursToRunConvertedToMinutes = HoursToRun * 60
         var TotalMinutesToRun = MinutesToRun + HoursToRunConvertedToMinutes
         var TotalSecondsToRun = TotalMinutesToRun * 60
        
        var MinutesForMileToSeconds = MinutesMile * 60
        var TotalSecondsForMile = MinutesForMileToSeconds + SecondsMile
        
        var MilesToRun = TotalSecondsToRun / TotalSecondsForMile
        OutletVariables.RouteDistance = MilesToRun
        println(OutletVariables.RouteDistance!)

        }
    }
  
    func textFieldShouldReturn(TextField: UITextField) -> Bool{
        if TextField == HoursRunning{
            HoursRunning.resignFirstResponder()
            MinutesRunning.becomeFirstResponder()
            }
        else if TextField == MinutesRunning{
            MinutesRunning.resignFirstResponder()
            MinutesMilePace.becomeFirstResponder()
        }
        else if TextField == MinutesMilePace{
            MinutesMilePace.resignFirstResponder()
            SecondsMilePace.becomeFirstResponder()
        }
        else if TextField  == SecondsMilePace{
            SecondsMilePace.becomeFirstResponder()
            self.CalculateRoute( nil )
            performSegueWithIdentifier("CalculatedDistance", sender: nil)
        }
        return true
        }
    override func viewDidLoad() {
        DistanceToRun.keyboardType = UIKeyboardType.DecimalPad
        DistanceToRun.returnKeyType = UIReturnKeyType.Done

        HoursRunning.keyboardType = UIKeyboardType.PhonePad
        MinutesRunning.keyboardType = UIKeyboardType.PhonePad
        MinutesMilePace.keyboardType = UIKeyboardType.PhonePad
        SecondsMilePace.keyboardType = UIKeyboardType.PhonePad

    }

    }



