//
//  EDCustomTopLoader.swift
//  EDLoader
//
//  Created by edoohwang on 7/29/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import UIKit

public class EDCustomTopLoader: EDLoader {

    // MARK: - Member
    /// arrow in loader
    var arrowView: UIImageView?
    /// waiting in loader
    var waitingView: UIImageView?
    
    /// the image is for free of loader state
    var imgForFree: UIImage?
    /// the image is for will loading of loader state
    var imgForWillLoading: UIImage?
    /// the image is for loading of loader state
    var imgForLoading: UIImage?
    
    /// loader的状态
    override var state: EDLoaderState {
        didSet { // 根据状态来做事
            
            if oldValue == state  {
                return
            }
            if state == .willLoad {
                arrowView?.image = imgForWillLoading
            } else if state == .free {
                arrowView?.image = imgForFree
            }  else if state == .loading {
                
                
                if initialSuperViewContentOffsetY == nil {
                    return
                }
                waitingView?.image = imgForLoading
                
                setNeedsDisplay()
                
                let offsetY = initialSuperViewContentOffsetY! - loaderHeight
                
                setSuperScrollViewOffsetY(offsetY)
                
                arrowView!.hidden = true
                waitingView!.hidden = false
                startAnimation()
                
                target!.performSelector(action!)
                
                return
            } else if state == .reset {
                
                arrowView!.hidden = false
                waitingView!.hidden = true
                stopAnimation()
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
    
    public override func setupSurface() {
        super.setupSurface()
        
        // initial arrowView
        arrowView = UIImageView(image: NSBundle.ed_arrowImage())
        addSubview(arrowView!)
        // initial waitingView
        waitingView = UIImageView(image: NSBundle.ed_waitingImage())
        addSubview(waitingView!)
        
        arrowView!.ed_center_x = self.ed_width/2
        arrowView!.ed_center_y = self.ed_height/2
        
        waitingView!.ed_center_x = self.ed_width/2
        waitingView!.ed_center_y = self.ed_height/2
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

    public func setImage(img: UIImage, state: EDLoaderState) {
        if state == .free {
            imgForFree = img
        } else if state == .loading {
            imgForLoading = img
        } else if state == .willLoad {
            imgForWillLoading = img
        }
    }
    
    private func startAnimation() -> () {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 2
        anim.repeatCount = MAXFLOAT
        
        // 防止切换控制器而消失
        anim.removedOnCompletion = false
        
        waitingView!.layer.addAnimation(anim, forKey: nil)
    }
    
    private func stopAnimation() {
        waitingView?.layer.removeAllAnimations()
    }
    
}
