

import UIKit


public class EDLoader: UIView {
    public enum EDLoaderState {
        /// 正在加载
        case loading
        /// 即将加载
        case willLoad
        /// 闲置
        case free
        /// 恢复初始状态
        case reset
    }
    
    // MARK: - Member
    /// 回调方法的对象
    var target: AnyObject?
    /// 回调方法
    var action: Selector?
    /// 没有获得父类初始化inset的时候要就刷新，true的时候会等待inset设置好了以后才才会执行beginRefresh
    var forceLoadingFlag = false

    /// 父控件
    var superScrollView: UIScrollView? {
        didSet {
            
            // 垂直方向永远有弹性
            superScrollView!.alwaysBounceVertical = true
            
            
            // 需要开启新线程才能获取正确的contenInset，原因不明
            dispatch_async(dispatch_get_main_queue()) {
                self.initialSuperViewContentOffsetY = (self.superScrollView?.ed_contentOffsetY())!
                self.superViewOriginalInset = self.superScrollView?.contentInset
                self.state = .free
                // 得到初始化inset的时候，如果需要的话，立刻开始刷新
                if self.forceLoadingFlag == true {
                    self.beginLoading()
                }
            }
            
        }
    }
    
    var superViewOriginalInset: UIEdgeInsets?
    
    /// 父控件滚动条最初的偏移量
    var initialSuperViewContentOffsetY: CGFloat?
    
    /// loader显示出来的百分比
    var viewDidShowPercentage: CGFloat = 0 {
        didSet {
            if loading() == true {
                return
            }
            alpha = viewDidShowPercentage <= 1 ? viewDidShowPercentage : 1
        }
    }
    
    /// loader的状态
    var state: EDLoaderState = EDLoaderState.free 
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame:  CGRect(x: 0, y: -loaderHeight, width: ed_screenW, height: loaderHeight))
        setupSurface()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     init(target: AnyObject, action: Selector) {
        self.init()
        self.target = target
        self.action = action
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     通过监听偏移来确定loader的状态，从而知道做什么
     
     */
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // 如果不在主窗口显示就直接返回
        if window == nil {
            return
        }
        
        let contenOffsetY = (superview as! UIScrollView).ed_contentOffsetY()
        
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
    // MARK: - Function
    /**
     begin animation and invoke function
     */
    func beginLoading() -> Void {}
    
    /**
     end annimation
     */
    func endLoading() -> Void {}
    
    public func loading() -> Bool {
        return state == .loading || state == .willLoad
    }
    /**
     调用入口，添加到一个scrollView即可
     
     */
    func setToScrollView(view: UIScrollView) -> Void {
        // 父控件必须是UIScrollView的子类
        
        view.addSubview(self)
        // 保存父控件
        superScrollView = view
        
        // 监听
        setupObserver()
    }
    
    /**
     初始化界面
     */
    func setupSurface() {}
    
    func setupObserver() {
        superScrollView!.addObserver(self, forKeyPath: EDContentOffsetKey, options: [NSKeyValueObservingOptions.New, .Old], context: nil)
        
    }
    
    func setSuperScrollViewOffsetY(offsetY: CGFloat) {
        
        UIView.animateWithDuration(ed_animationDurution) {
            self.superScrollView!.ed_insetTop = -offsetY
        }
    }
    
    
    
}
