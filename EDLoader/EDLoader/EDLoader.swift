

import UIKit


class EDLoader: UIView {
    enum EDLoaderState {
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
    private var target: AnyObject?
    /// 回调方法
    private var action: Selector?
    /// 没有获得父类初始化inset的时候要就刷新，true的时候会等待inset设置好了以后才才会执行beginRefresh
    private var forceLoadingFlag = false
    /// fresh高度
    private let loaderHeight: CGFloat = 50
    /// 箭头图标
    private lazy var arrowView: UIImageView = {
        
        
        let av = UIImageView(image: NSBundle.ed_arrowImage())
        self.addSubview(av)
        return av
    }()
    /// 等待图标
    private lazy var waitingView: UIActivityIndicatorView = {
        
        let wv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        wv.hidden = true
        self.addSubview(wv)
        return wv
    }()
    /// 父控件
    private var superScrollView: UIScrollView? {
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
    
    private var superViewOriginalInset: UIEdgeInsets?
    
    /// 父控件滚动条最初的偏移量
    private var initialSuperViewContentOffsetY: CGFloat?
    
    /// loader显示出来的百分比
    private var viewDidShowPercentage: CGFloat = 0 {
        didSet {
            if loading() == true {
                return
            }
            alpha = viewDidShowPercentage <= 1 ? viewDidShowPercentage : 1
        }
    }
    
    /// loader的状态
    private var state: EDLoaderState = EDLoaderState.free {
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
    
    public class func loader(target: AnyObject, action: Selector) -> EDLoader {
        let obj = EDLoader.init(target: target, action: action)
        return obj
    }
   
    init(target: AnyObject, action: Selector) {
        self.init()
        self.target = target
        self.action = action
    }
    override init(frame: CGRect) {
        
        super.init(frame:  CGRect(x: 0, y: -loaderHeight, width: ed_screenW, height: loaderHeight))
        setupSurface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     通过监听偏移来确定loader的状态，从而知道做什么
     
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
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
    func beginLoading() -> Void {
        if initialSuperViewContentOffsetY == nil {
            forceLoadingFlag = true
        }
        
        
        self.viewDidShowPercentage = 1
        self.state = .loading
    }
    func endRefresh() -> Void {
        state = .reset
    }
    func loading() -> Bool {
        return state == .loading || state == .willLoad
    }
    /**
     调用入口，添加到一个scrollView即可
     
     */
    func setToScrollView(view: UIScrollView) -> Void {
        // 父控件必须是UIScrollView的子类
        setupSurface()
        
        view.addSubview(self)
        // 保存父控件
        superScrollView = view
        
        // 监听
        setupObserver()
    }
    
    private func setupSurface() {
        arrowView.ed_center_x = self.ed_width/2
        arrowView.ed_center_y = self.ed_height/2
        
        waitingView.ed_center_x = self.ed_width/2
        waitingView.ed_center_y = self.ed_height/2
    }
    
    private func setupObserver() {
        superScrollView!.addObserver(self, forKeyPath: EDContentOffsetKey, options: [NSKeyValueObservingOptions.New, .Old], context: nil)
        
    }
    
    private func setSuperScrollViewOffsetY(offsetY: CGFloat) {
        
        UIView.animateWithDuration(ed_animationDurution) {
            self.superScrollView!.ed_insetTop = -offsetY
        }
    }
    
    
    
}
