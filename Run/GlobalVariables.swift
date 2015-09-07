//
//  GlobalVariables.swift
//  Run
//
//  Created by Steven Li on 8/26/15.
//  Copyright (c) 2015 Steven Li. All rights reserved.
//

import Foundation

class Main {
    var GlobalDistanceToRun:Double?
    init(TempDistanceToRun:Double) {
     self.GlobalDistanceToRun = TempDistanceToRun
    }
}

var mainInstance = Main(TempDistanceToRun: 0)