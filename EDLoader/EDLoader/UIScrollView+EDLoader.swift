//
//  UIScrollView+EDExtension.swift
//  EDWBLoaction
//
//  Created by edoohwang on 7/27/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
     public var ed_topLoader: EDTopLoader {
        get {
            return objc_getAssociatedObject(self, &memberHeadLoaderKey) as! EDTopLoader
        }
        set {
            let value = newValue as EDTopLoader
            value.setToScrollView(self)
            objc_setAssociatedObject(self, &memberHeadLoaderKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    func ed_contentOffsetY() -> CGFloat {
        return contentOffset.y
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
    
}
