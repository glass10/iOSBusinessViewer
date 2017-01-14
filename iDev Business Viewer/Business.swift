//
//  Business.swift
//  iDev Business Viewer
//
//  Created by Cameron Glass on 1/13/17.
//  Copyright © 2017 Cameron Glass. All rights reserved.
//

import UIKit
import SwiftyJSON

class Business: NSObject {
    
    var name: String = ""
    var price: String = ""
    var location: String = ""
    var rating: Double = 0.0
    var distance: Double = 0.0
    var phoneNumber: String = ""
    var type: String = ""
    var imageURL: String = ""
    
    init(json: JSON) {
        name = json["name"].stringValue;
        price = json["price"].stringValue;
        location = "\(json["location"]["address1"].stringValue), \(json["location"]["city"].stringValue)"
        rating = json["rating"].doubleValue;
        distance = json["distance"].doubleValue;
        phoneNumber = json["phone"].stringValue;
        imageURL = json["image_url"].stringValue;
        
        let types = json["categories"].arrayValue;
        
        for type in types {
            if(self.type == ""){
                self.type.append(type["alias"].stringValue)
            } else{
                 self.type.append(", \(type["alias"].stringValue)")
            }
            print(self.type)
        }
        
    }

}
