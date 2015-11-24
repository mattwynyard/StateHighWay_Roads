//
//  ChristchurchRoadEvent.swift
//  RoadInfo
//
//  Created by Matt Wynyard on 9/11/15.
//  Copyright © 2015 Niobium. All rights reserved.
//

import Foundation

class ChristchurchEvent: CustomStringConvertible {
    
    var id: String!
    var title: String!
    var address: String!
    var startDate: String!
    var endDate: String!
    var publicDescription: String!
    var roadClosureStatus: String!
    var lastUpdated: NSDate!
    var jobType: String!
    var significance: String!
    var timeOfDay: String!
    var jobLevels:  NSMutableArray = []
    var trafficImpacts: NSMutableArray = []
    var locations: NSMutableArray = []

    
    var description: String {
        get {
            return ""
        }
    }
    
}