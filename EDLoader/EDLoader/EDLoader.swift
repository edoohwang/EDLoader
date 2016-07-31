

import UIKit


public class EDLoader: UIView {
    public enum EDLoaderState {
        /// 正在加载
        case loading
        /// 即将加载
        case willLoad
        /// 闲置
        case free
    }
    
    // MARK: - Member
    /// 回调方法的对象
    var target: AnyObject?
    /// 回调方法
    var action: Selector?
    /// 没有获得父类初始化inset的时候要就刷新，true的时候会等待inset设置好了以后才才会执行beginRefresh
    public var forceLoadingFlag = false

    /// 父控件
    weak var superScrollView: UIScrollView? {
        didSet {
            loaderWillAddToSrollView()
        }
    }
    
    var superViewOriginalInset: UIEdgeInsets?
    
    /// 父控件滚动条最初的偏移量
    var initialSuperViewContentOffsetY: CGFloat?
    
    /// loader显示出来的百分比
    var viewDidShowPercentage: CGFloat = 0 
    /// loader的状态
    var state: EDLoaderState?
    
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(target: AnyObject, action: Selector) {
        self.init()
        self.target = target
        self.action = action
        setupSurface()
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    // MARK: - Function for children to invoke
    /**
     begin animation and invoke function
     */
    public func beginLoading() -> Void {}
    
    /**
     end annimation
     */
    public func endLoading() -> Void {}
    
    /**
     judge wether loding
    
     */
    public func loading() -> Bool {
        return true
    }

    
    /**
     初始化界面,子类调用
     */
    public func setupSurface() {}
    
    
    /**
     this function be invoked when menber superScrollView did set
     */
    func loaderWillAddToSrollView() {
        setupObserver()
        
        // must get real number in a new thread, I don't know what reason,under code is wrong
//        initialSuperViewContentOffsetY = (superScrollView?.ed_insetTop)!
//        superViewOriginalInset = superScrollView?.contentInset
//        state = .free
    }
    
    
    /**
     setup the observer
     */
    func setupObserver() {
        superScrollView?.addObserver(self, forKeyPath: EDContentSizeKey, options: [.New, .Old], context: nil)
        superScrollView?.addObserver(self, forKeyPath: EDContentOffsetKey, options: [.New, .Old], context: nil)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // 不允许交互直接返回
        if self.userInteractionEnabled == false {
            return
        }
        // contentSize的变化无时不刻都要监听，因为这个key的改变用于重新调整位置
        if keyPath == EDContentSizeKey {
            contentSizeDidChange()
        }
        
        if !self.hidden {
        // contentOffset的变化通常用于触发动画的改变，所有隐藏了将不再监听
            if keyPath == EDContentOffsetKey {
                contentOffsetDidChange()
            }
        }
    }
    
    
    func contentSizeDidChange() {}
    func contentOffsetDidChange() {}
    

    
 
 
    
    
    
}
