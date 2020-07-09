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
    var fromID     : String?
    var text       : String?
    var timeStamp  : NSNumber?
    var toID       : String?

    func chatPartner() -> String? {
         return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
   
}
