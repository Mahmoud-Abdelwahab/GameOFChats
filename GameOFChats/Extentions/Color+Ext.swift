//
//  Color+Ext.swift
//  GameOFChats
//
//  Created by kasper on 7/3/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
extension UIColor  {
    
    convenience init(r : CGFloat , g : CGFloat , b : CGFloat) {
        self.init(red : r/255 , green : g/255 , blue : b/255 , alpha : 1)
        
    }
}
