

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
    public var target: AnyObject?
    /// 回调方法
    public var action: Selector?
    /// 没有获得父类初始化inset的时候要就刷新，true的时候会等待inset设置好了以后才才会执行beginRefresh
    public var forceLoadingFlag = false

    /// 父控件
    weak var superScrollView: UIScrollView? 
    
    var superViewOriginalInset: UIEdgeInsets?
    
    /// 父控件滚动条最初的偏移量
    var initialSuperViewContentOffsetY: CGFloat?
    
    /// loader显示出来的百分比
    var viewDidShowPercentage: CGFloat = 0 
    /// loader的状态
    var state: EDLoaderState?
    
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame:  CGRect(x: 0, y: -loaderHeight, width: ed_screenW, height: loaderHeight))
        setupSurface()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(target: AnyObject, action: Selector) {
        self.init()
        self.target = target
        self.action = action
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    // MARK: - Function
    /**
     begin animation and invoke function
     */
    public func beginLoading() -> Void {}
    
    /**
     end annimation
     */
    public func endLoading() -> Void {}
    
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
    }
    
    /**
     初始化界面
     */
    public func setupSurface() {}
    
 
    func setSuperScrollViewOffsetY(offsetY: CGFloat) {
        
        UIView.animateWithDuration(ed_animationDurution) {
            self.superScrollView!.ed_insetTop = -offsetY
        }
    }
    
    
    
}
