//
//  ViewController.swift
//  RoadInfo
//
//  Created by Matt Wynyard on 5/11/15.
//  Copyright © 2015 Niobium. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var roadEvents: [RoadEvent]! = nil
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var eventArray: [RoadEvent]!
    var xmlParser: XMLParser? = nil
    var annotations = [Annotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        var running = true
        let request = NSURL(string: "https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TREIS/REST/FeedService/")!
        
        httpGet(request) {
            (responseData, xmlString, error) -> Void in
            if error != nil {
                print(error!)
                running = false
            } else {
                //print(xmlString)
                self.xmlParser = XMLParser(data: responseData)
                self.eventArray = self.xmlParser?.getEventArray()
                running = false
            }
        }
        
        while(running) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate())
            
            
        }
        var i: Int; var j: Int
        for event in eventArray {
            let array  = event.coordinatesWSG84
            let count: Int = array.count
            let eventType = event.eventType
            
            
            for i = 0; i < count; i++ {
                //var tuple = Array<Coordinate>()
                for j = 0; j < array[i].count; j++ {
                    let lat: Double = array[i][j].0
                    let long: Double = array[i][j].1
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let annotation = Annotation(title: eventType!, coordinate: coordinate)
                    annotations.append(annotation)
                }
                
            }
        }
        mapView.addAnnotations(annotations)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let centre = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
       
        
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Annotation {
            let identifier = "triangle"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func httpGet(request: NSURL!, callback: (NSData, String, String?) -> Void) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["username" : "mjwynyard", "password" : "Copper2004"]
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithURL(request){
            (data, response, error) -> Void in
            if error != nil {
                let errorData = NSData()
                callback(errorData, "", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                callback(data!, result as String, nil)
            }
        }
        task.resume()
    }


}

