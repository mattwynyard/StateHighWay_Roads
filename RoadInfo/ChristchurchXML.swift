//
//  ChristchurchXML.swift
//  RoadInfo
//
//  Created by Matt Wynyard on 9/11/15.
//  Copyright © 2015 Niobium. All rights reserved.
//

import Foundation

class ChristchurchXML: NSObject, NSXMLParserDelegate {
    
    let parser: NSXMLParser!
    let _data: NSData!
    var eventArray = [ChristchurchEvent]()
    var count: Int = -1
    var locationCount = -1
    var currentElement: String! = nil
    var jobLevels: Bool = false
    var trafficImpacts: Bool = false
    var locations: Bool = false

    init(data: NSData) {
        parser = NSXMLParser(data: data)
        self._data = data
        super.init()
        parser.delegate = self
        parser.parse()
    }
    
    
    func parserDidStartDocument(parser: NSXMLParser) {
        print("Start parsing")
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        print("Finished parsing")
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "tns:id" {
            eventArray.append(ChristchurchEvent())
            locationCount = -1
            count++
        }

        currentElement = elementName
        if currentElement == "tns:jobLevels" {
            jobLevels = true
            trafficImpacts = false
            locations = false
        } else if currentElement == "tns:trafficImpacts" {
            jobLevels = false
            trafficImpacts = true
            locations = false
        } else if currentElement == "tns:locations" {
            jobLevels = false
            trafficImpacts = false
            locations = true
        } else {
            
        }
            print(currentElement)
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        print(string)
        
        switch currentElement {
        case "tns:id":
            eventArray[count].id = string
        case "tns:title":
            eventArray[count].id = string
        case "tns:address":
            eventArray[count].id = string
        case "tns:publicDescription":
            eventArray[count].id = string
        case "tns:roadClosureStatus":
            eventArray[count].id = string
        case "tns:lastUpdated":
            let date: NSDate = formatDate(string)
            eventArray[count].lastUpdated = date
        case "tns:jobType":
            eventArray[count].id = string
        case "tns:significance":
            eventArray[count].id = string
        case "tns:timeOfDay":
            eventArray[count].id = string
//        case "tns:jobLevels":
//            jobLevels = true
//            trafficImpacts = false
//            locations = false
//            print("jobLevels")
//        case "tns:locations":
//            locations = true
//            jobLevels = false
//            trafficImpacts = false
        case "tns:item":
            //print(string)
            if jobLevels == true && trafficImpacts == false && locations == false {
                eventArray[count].trafficImpacts.addObject(string)
                
            } else if trafficImpacts == true && jobLevels == false && locations == false {
                eventArray[count].trafficImpacts.addObject(string)
                //print("trafficImpact")
            } else if trafficImpacts == false && jobLevels == false && locations == true {
                print("location")
            } else {
                print("error")
            }

        case "tns:type":
            locationCount++
            print(locationCount)
             eventArray[count].locations.addObject(Location())
            let location = eventArray[count].locations.objectAtIndex(locationCount) as! Location
            location.type = string
            
        case "tns:dataType":
            let location = eventArray[count].locations.objectAtIndex(locationCount) as! Location
            location.dataType = string
        case "tns:coordinates":
            //let location = eventArray[count].locations.objectAtIndex(locationCount) as! Location
            //if let json: NSDictionary = NSJSONSerialization.
            print(string)
        default:
            break
            
        }

    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("validation error \(validationError.description)")
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("parse error \(parseError.description)")
        print(count)
    }
    
    func formatDate(date: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let localDate = formatter.dateFromString(date)
        return localDate!
    }
    
    
}