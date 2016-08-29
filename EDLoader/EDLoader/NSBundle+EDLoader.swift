

import Foundation
import UIKit

extension NSBundle {

    class func ed_loderBundle() -> AnyObject {
     let path = NSBundle(forClass: EDLoader.self).pathForResource("EDLoader", ofType: "bundle")!
        return NSBundle(path: path)!
    }
    
    class func ed_arrowImage() -> (UIImage) {
        let img = UIImage(contentsOfFile: ed_loderBundle().pathForResource("arrow@2x", ofType: "png")!)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        return img!
    }
    
    class func ed_waitingImage() -> (UIImage) {
        let img = UIImage(contentsOfFile: ed_loderBundle().pathForResource("waiting@2x", ofType: "png")!)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        return img!
    }
}