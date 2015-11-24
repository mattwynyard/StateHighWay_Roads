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
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    var image: UIImage! = nil
    var event: RoadEvent! = nil
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, event: RoadEvent) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.event = event
        super.init()
    }
}

//    var image: UIImage {
//        get {
//            return self.image
//        }
//        set(newValue) {
//            self.image = newValue
//        }
    
//    var subtitle: String {
//        return type
//    }
//}