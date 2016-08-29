

import UIKit

public class EDCustomTopLoader: EDTopLoader {

    // MARK: - Member
    /// arrow in loader
    private var arrowView: UIImageView?
    /// waiting in loader
    private var waitingView: UIImageView?
    
    /// the image is for free of loader state
    private var imgForFree: UIImage?
    /// the image is for will loading of loader state
    private var imgForWillLoading: UIImage?
    /// the image is for loading of loader state
    private var imgForLoading: UIImage?
    
    /// loader的状态
    override  var state: EDLoaderState? {
        didSet { // 根据状态来做事
            
            if oldValue == state  {
                return
            }
            if state == .willLoad {
                arrowView?.image = imgForWillLoading
            } else if state == .free {
                
                arrowView!.hidden = false
                waitingView!.hidden = true
                stopAnimation()
                setSuperScrollViewOffsetY(-initialSuperViewContentOffsetY!)
                UIView.animateWithDuration(ed_animationDurution, animations: {
                    self.viewDidShowPercentage = 0
                })
                arrowView?.image = imgForFree
            }  else if state == .loading {
                
                
                if initialSuperViewContentOffsetY == nil {
                    return
                }
                waitingView?.image = imgForLoading
                
                setNeedsDisplay()
                
                let offsetY = initialSuperViewContentOffsetY! - loaderHeight
                
                setSuperScrollViewOffsetY(-offsetY)
                
                arrowView!.hidden = true
                waitingView!.hidden = false
                startAnimation()
                
                target!.performSelector(action!)
                
                return
            }
        }
    }
    
    
    
    // MARK: - Initialization
    
    

    
    public override func setupSurface() {
        super.setupSurface()
        
        // initial arrowView
        arrowView = UIImageView(image: NSBundle.ed_arrowImage())
        addSubview(arrowView!)
        // initial waitingView
        waitingView = UIImageView(image: NSBundle.ed_waitingImage())
        addSubview(waitingView!)
        
        layoutIfNeeded()
      
    }
    // MARK: - Function


    /**
     set the Image for the different state
     
     - parameter img:   image to show
     - parameter state: when the image will show
     */
    public func setImage(img: UIImage, state: EDLoaderState) {
        if state == .free {
            imgForFree = img
        } else if state == .loading {
            imgForLoading = img
        } else if state == .willLoad {
            imgForWillLoading = img
        }
        
        arrowView?.sizeToFit()
        waitingView?.sizeToFit()
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        
        arrowView!.ed_center_x = self.ed_width/2
        arrowView!.ed_center_y = self.ed_height/2
        
        waitingView!.ed_center_x = self.ed_width/2
        waitingView!.ed_center_y = self.ed_height/2
        
    }
    
}
