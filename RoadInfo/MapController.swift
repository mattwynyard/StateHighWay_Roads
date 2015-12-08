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
import Foundation

class MapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, URLConnectionDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var roadEvents: [RoadEvent]! = nil
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var eventArray: [RoadEvent]!
    var xmlParser: XMLParser? = nil
    var chchParser: ChristchurchXML? = nil
    var annotations = [Annotation]()
    var polylines = [MKPolyline]()
    let request = NSURL(string: "https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TREIS/REST/FeedService/")!
    //var request = NSURL(string: "https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TMP/REST/FeedService/")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.pitchEnabled = false
        self.mapView.rotateEnabled = false
        let url:  URLConnection = URLConnection()
        url.delegate = self
        url.loadData(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setRoadEvents(events: [RoadEvent]) {
        eventArray = events
    }

    func processHighwayData() {
        var i: Int; var j: Int
        for event in eventArray {
            let currentEvent = event
            let array  = event.coordinatesWSG84
            let count: Int = array.count
            let eventType = event.eventType
            print(eventType!)
            let impact = event.impact
            let eventComments = event.eventComments
            //let eventType = event.eventType
            for i = 0; i < count; i++ {
                var polyline = [CLLocationCoordinate2D]()
                for j = 0; j < array[i].count; j++ {
                    let lat: Double = array[i][j].0
                    let long: Double = array[i][j].1
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    if array[i].count <= 1 {
                        let annotation = Annotation(title: impact!, subtitle: eventType!, coordinate: coordinate, event: currentEvent)
                        annotationImage(annotation, event: event.impact!)
                    } else {
                        polyline.append(coordinate)
                    }
                }
                if polyline.count != 0 {
                    let annotation = Annotation(title: impact!, subtitle: eventType!, coordinate: polyline[0], event: currentEvent)
                    annotationImage(annotation, event: event.impact!)
                    annotations.append(annotation)
                }
                self.mapView.addOverlay(MKPolyline(coordinates: &polyline, count: array[i].count))
            } //end for
        }
        self.mapView.addAnnotations(annotations)
    }
    
    /**
     Assigns image to the annotation depending on the event type and appends
     annotation to the annotations array.
     - Parameter annotation: The annotation.
     - Parameter: the type of event
     */
    func annotationImage(annotation: Annotation, event: String) {
        
        switch event {
        case "Road Work":
            annotation.image = UIImage(named: "orange-warning-sign16px.png")!
        case "Crash":
            annotation.image = UIImage(named: "black-warning-sign16px.png")!
        case "Delays":
            annotation.image = UIImage(named: "yellow-warning-sign16px.png")!
        case "Caution":
            annotation.image = UIImage(named: "yellow-warning-sign16px.png")!
        case "Road Closed":
            annotation.image = UIImage(named: "red-warning-sign16px.png")!
        default:
            break
        }

        annotations.append(annotation)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        //if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.redColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        //}
        //return nil
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
            var view: MKAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//                as MKAnnotationView! { // 2
//                    dequeuedView.annotation = annotation
//                    view = dequeuedView
//            } else {
                // 3
                //view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                //view.image = UIImage(named: "red-warning-sign16px.png")
                view.image = annotation.image
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            //}
            return view
        }
        return nil
    }
    
    /**
     Instantiates a EventViewController when disclosure button on annotation is tapped
     and sets the event property to the event that has been tapped
     - Parameter mapView: The mapview.
     - Parameter view: the annoatation view
     - Paramter control: The disclosure button
     */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            
            let annotation = view.annotation as! Annotation
            let event = annotation.event
            
            if control == view.rightCalloutAccessoryView {
                
                let destination = self.storyboard!.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
                self.navigationController!.pushViewController(destination, animated: true)
                //let destination = EventViewController()
                //navigationController?.pushViewController(destination, animated: true)
                destination.event = event

            }
            
    }
    



}

