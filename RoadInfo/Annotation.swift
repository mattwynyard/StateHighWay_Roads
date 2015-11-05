//
//  Annotation.swift
//  RoadInfo
//
//  Created by Matt Wynyard on 5/11/15.
//  Copyright © 2015 Niobium. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
//    var subtitle: String {
//        return type
//    }
}