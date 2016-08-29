

import UIKit

public class EDFootLoader: EDLoader {
    // MARK: Member
    /// tabBar挡住scrollView的高度，给用户设置自定义，默认为0
    public var offsetHeightForTabBar: CGFloat = 0
    /// 上一次使用footLoader加载数据之后的contenSize高度
    var lastLoadedcontentSizeH: CGFloat?
    /// 底部控件将要出现的偏移量
    var footLoaderWillShowOffsetY: CGFloat = 0
   
    
    /// a flag that wether operate in funtion observeValueForKeyPath
    private var ignoreThisSizeChange: Bool = false
    
   
    
    // MARK: Initialiaztion
    public override init(frame: CGRect) {
        super.init(frame:  CGRect(x: 0, y: 0, width: ed_screenW, height: loaderHeight))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // MARK: - Private Function
    
    func footBtnClicked() -> Void {
        state = .loading
    }
    
    override func loaderWillAddToSrollView() {
        super.loaderWillAddToSrollView()
        // 需要开启新线程才能获取正确的contenInset，原因不明
        dispatch_async(dispatch_get_main_queue()) {
            self.initialSuperViewContentOffsetY = (self.superScrollView?.ed_contentOffsetY)!
            self.superViewOriginalInset = self.superScrollView?.contentInset
            self.state = .free
            self.ed_top = (self.superScrollView?.contentSize.height)!
        }
    }
    
    
    override func contentOffsetDidChange() {
        super.contentOffsetDidChange()
        
        // 如果不在主窗口显示就直接返回
        if window == nil {
            return
        }
        
  
        
        let contenOffsetY = (superview as! UIScrollView).ed_contentOffsetY
        
        
        // 如果footLoader没有出现，直接返回
        if contenOffsetY < footLoaderWillShowOffsetY {
            return
        }
        
        
        
        // 判断当前loader的状态
        if superScrollView?.dragging == true
        {
            if contenOffsetY > footLoaderWillShowOffsetY+ed_loadingOffset
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
    
    override func contentSizeDidChange() {
        super.contentSizeDidChange()
        if initialSuperViewContentOffsetY == nil {
            return
        }
        // 初始化上一次加载后的contentsize高度
        if lastLoadedcontentSizeH == nil {
            lastLoadedcontentSizeH = superScrollView?.ed_contentSizeH
        }
        
        // 初始化footLoader即将出现时候的偏移量
        footLoaderWillShowOffsetY = (superScrollView?.ed_contentSizeH)! - ed_screenH + initialSuperViewContentOffsetY! + offsetHeightForTabBar
        if ignoreThisSizeChange == true {
            ignoreThisSizeChange = false
            return
        }
       
        // 初始化footLoader的顶部位置
        self.ed_top = (superScrollView?.contentSize.height)!
        
        ignoreThisSizeChange = true
        superScrollView?.ed_contentSizeH = self.ed_top + loaderHeight
 
    }
    
    
    public override func setupSurface() {
        super.setupSurface()
    }
    
    // MARK: Function
    public override func beginLoading() {
        state = .loading
    }
    
    public override func endLoading() {
        state = .free
    }
    
    /**
     没有更多数据如何处理，用于子类调用
     */
    public func noMoreData() {}
 
    public override func loading() -> Bool {
        return state == .loading || state == .willLoad
    }
    
    
    
}
