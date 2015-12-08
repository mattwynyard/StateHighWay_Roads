//
//  URLConnection.swift
//  RoadInfo
//
//  Created by Matt Wynyard on 28/11/15.
//  Copyright © 2015 Niobium. All rights reserved.
//

import Foundation

internal protocol URLConnectionDelegate {
    
    func setRoadEvents(events: [RoadEvent])
    func processHighwayData()
}

class URLConnection: NSObject, NSURLSessionDelegate {
    
    var xmlParser: XMLParser? = nil
    var eventArray: [RoadEvent]!
    var delegate:URLConnectionDelegate? = nil
    
    var events: [RoadEvent]! {
        get {
        return eventArray
        }
        set(newValue) {
            eventArray = newValue
        }
    }
    
    func httpGet(request: NSMutableURLRequest!, callback: (NSData, String?) -> Void) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["username" : "mjwynyard", "password" : "Copper2004"]
        let session = NSURLSession(configuration: config)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: {(data, response, error) in
                if error != nil {
                    callback(data!, error?.localizedDescription)
                } else {
                    callback(data!, nil)
                    session.invalidateAndCancel()
                }
        })
        task.resume()
    }
    
    func loadData(request: NSURL) {
        httpGet(NSMutableURLRequest(URL: request)) {
            (responseData, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                //print(NSString(data: responseData, encoding: NSASCIIStringEncoding)!)
                self.xmlParser = XMLParser(data: responseData)
                //self.chchParser = ChristchurchXML(data: responseData)
                self.events = self.xmlParser?.getEventArray()
                self.delegate?.setRoadEvents(self.events)
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.processHighwayData()
                })
            }
        }
    }
}
