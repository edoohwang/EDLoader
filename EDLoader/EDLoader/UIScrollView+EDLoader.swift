

import Foundation
import UIKit

extension UIScrollView {
    
     public var ed_topLoader: EDTopLoader {
        get {
            return objc_getAssociatedObject(self, &memberHeadLoaderKey) as! EDTopLoader
        }
        set {
            newValue.setToScrollView(self)
            objc_setAssociatedObject(self, &memberHeadLoaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var ed_footLoader: EDFootLoader {
        get {
            return objc_getAssociatedObject(self, &memberFootLoaderKey) as! EDFootLoader
        }
        set {
            newValue.setToScrollView(self)
            objc_setAssociatedObject(self, &memberFootLoaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    

    
    var ed_contentOffsetY: CGFloat {
        get {
            return contentOffset.y
        }
        set {
            var offset = contentOffset
            offset.y = newValue
            contentOffset = offset
        }
    }
    
    var ed_insetTop: CGFloat {
        get {
            return contentInset.top
        }
        set {
            var inset = contentInset
            inset.top = newValue
            contentInset = inset
        }
    }
    
    var ed_contentSizeH: CGFloat {
        get {
            return contentSize.height
        }
        set {
            var size = contentSize
            size.height = newValue
            contentSize = size
        }
    }
    
}
