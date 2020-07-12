//
//  Message.swift
//  GameOFChats
//
//  Created by kasper on 7/6/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase
class Message : NSObject {
    var fromID      : String?
    var text        : String?
    var toID        : String?
    var imageUrl    : String?
    var timeStamp   : NSNumber?
    var imageHeight : NSNumber?
    var imageWidth  : NSNumber?
    
    func chatPartner() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
    
    
    init(dictionary: [String: Any]) {
        
        self.fromID                 =  dictionary["fromID"] as? String
        self.text                   =  dictionary["text"] as? String
        self.toID                   =  dictionary["toID"] as? String
        self.imageUrl               =  dictionary["imageUrl"] as? String
        self.imageHeight            =  dictionary["imageHeight"] as? NSNumber
        self.imageWidth             =  dictionary["imageWidth"] as? NSNumber
        self.timeStamp              =  dictionary["timeStamp"] as? NSNumber
      
    }
    
    
}
