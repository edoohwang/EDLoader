

import Foundation
import UIKit

extension UIView {
    
    var ed_x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    
    var ed_y: CGFloat {
        get {
             return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    

    
    var ed_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    

    
    var ed_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    

    
    var ed_center_x: CGFloat {
        get {
              return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    
    
    var ed_center_y: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    

    
    var ed_top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
             frame.origin.y = newValue
        }
    }
    

    
    var ed_left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    
    var ed_right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }

    
    var ed_bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
             frame.origin.y = newValue - frame.size.height
        }
    }
}
