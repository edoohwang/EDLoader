

import UIKit

public class EDTopLoader: EDLoader {

    // MARK: - Member
 
    /// loader显示出来的百分比
    override var viewDidShowPercentage: CGFloat {
        didSet {
            if loading() == true {
                return
            }
            alpha = viewDidShowPercentage <= 1 ? viewDidShowPercentage : 1
        }
    }
    
  
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame:  CGRect(x: 0, y: -loaderHeight, width: ed_screenW, height: loaderHeight))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

 

    override public func setupSurface() {
        super.setupSurface()
 
       
    }
    // MARK: - Private Function
 
    override func loaderWillAddToSrollView() {
        
        super.loaderWillAddToSrollView()
        
        // 垂直方向永远有弹性
        superScrollView!.alwaysBounceVertical = true
        
        // 需要开启新线程才能获取正确的contenInset，原因不明
        dispatch_async(dispatch_get_main_queue()) {
            self.initialSuperViewContentOffsetY = -(self.superScrollView?.ed_insetTop)!
            self.superViewOriginalInset = self.superScrollView?.contentInset
            self.state = .free
            // 得到初始化inset的时候，如果需要的话，立刻开始刷新
            if self.forceLoadingFlag == true {
                self.beginLoading()
            }
        }
    }
    
    
    override func contentOffsetDidChange() {
        super.contentOffsetDidChange()
        
        // 如果不在主窗口显示就直接返回
        if window == nil {
            return
        }
        
        let contenOffsetY = (superview as! UIScrollView).ed_contentOffsetY
        
        // 如果已经向上滚动的话，直接返回
        if contenOffsetY > initialSuperViewContentOffsetY {
            return
        }
        
        
        viewDidShowPercentage = fabs((contenOffsetY-initialSuperViewContentOffsetY!) / loaderHeight)
        
        // 判断当前loader的状态
        if superScrollView?.dragging == true
        {
            if contenOffsetY < initialSuperViewContentOffsetY!-ed_loadingOffset
            {
                state = .willLoad
            }
            else
            {
                state = .free
            }
        }
        else if state == .willLoad
        {
            state = .loading
        }
    }
 
    /**
     set top of contentInset to superView
     
     */
    func setSuperScrollViewOffsetY(offsetY: CGFloat) {
        
        UIView.animateWithDuration(ed_animationDurution) {
            self.superScrollView!.ed_insetTop = offsetY
        }
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
        state = .free
    }
    
    public override func loading() -> Bool {
        return state == .loading || state == .willLoad
    }
    
    
    
    
}
