//
//  EDTopLoader.swift
//  EDLoader
//
//  Created by edoohwang on 7/29/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import UIKit

public class EDTopLoader: EDLoader {

    // MARK: - Member
    public lazy var arrowView: UIImageView = {
    
        let av = UIImageView(image: NSBundle.ed_arrowImage())
        self.addSubview(av)
        return av
    }()
    /// 等待图标
    public lazy var waitingView: UIActivityIndicatorView = {
        
        let wv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        wv.hidden = true
        self.addSubview(wv)
        return wv
    }()
    
    /// loader的状态
    override var state: EDLoaderState {
        didSet { // 根据状态来做事
            
            if oldValue == state  {
                return
            }
            if state == .willLoad {
                UIView.animateWithDuration(ed_animationDurution, animations: {
                    self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, CGFloat(M_PI)-0.000000000001)
                })
            } else if state == .free {
                UIView.animateWithDuration(ed_animationDurution, animations: {
                    self.arrowView.transform = CGAffineTransformIdentity
                })
                
            }  else if state == .loading {
                
                
                if initialSuperViewContentOffsetY == nil {
                    return
                }
                
                setNeedsDisplay()
                
                let offsetY = initialSuperViewContentOffsetY! - loaderHeight
                
                setSuperScrollViewOffsetY(offsetY)
                
                arrowView.hidden = true
                waitingView.hidden = false
                waitingView.startAnimating()
                
                target!.performSelector(action!)
         
                return
            } else if state == .reset {
                
                arrowView.hidden = false
                waitingView.hidden = true
                waitingView.stopAnimating()
                setSuperScrollViewOffsetY(initialSuperViewContentOffsetY!)
                UIView.animateWithDuration(ed_animationDurution, animations: {
                    self.viewDidShowPercentage = 0
                    self.state = .free
                })
            }
        }
    }
    
    
    // MARK: - Initialization
    
    
    public convenience init(target: AnyObject, action: Selector) {
        self.init()
        self.target = target
        self.action = action
    }

    override func setupSurface() {
        super.setupSurface()
 
        arrowView.ed_center_x = self.ed_width/2
        arrowView.ed_center_y = self.ed_height/2
        
        waitingView.ed_center_x = self.ed_width/2
        waitingView.ed_center_y = self.ed_height/2
    }
    // MARK: - Function
    /**
     begin animation and invoke function
     */
    public override func beginLoading() -> Void {
        if initialSuperViewContentOffsetY == nil {
            forceLoadingFlag = true
        }
        
        
        self.viewDidShowPercentage = 1
        self.state = .loading
    }
    
    
    public override func endLoading() {
        super.endLoading()
        state = .reset
    }
    
    
}
