//
//  NSBundle+EDLoader.swift
//  EDLoader
//
//  Created by edoohwang on 7/28/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import Foundation
import UIKit

extension NSBundle {

    class func ed_loderBundle() -> AnyObject {
     let path = NSBundle(forClass: EDLoader.self).pathForResource("EDLoader", ofType: "bundle")!
        return NSBundle(path: path)!
    }
    
    class func ed_arrowImage() -> (UIImage) {
        let img = UIImage(contentsOfFile: ed_loderBundle().pathForResource("arrow@2x", ofType: "png")!)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        return img!
    }
}