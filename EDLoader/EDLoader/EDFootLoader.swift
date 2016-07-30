//
//  EDFootLoader.swift
//  EDLoader
//
//  Created by edoohwang on 7/30/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import UIKit

public class EDFootLoader: EDLoader {
    // MARK: Member
    /// 底部控件将要出现的偏移量
    var footViewWillShowOffsetY: CGFloat = 0
    /// bottom button for superView
    private lazy var footBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.backgroundColor = UIColor.brownColor()
        

        
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.setTitle("点击或者上拉加载更多", forState: UIControlState.Normal)
        
        
        
        self.addSubview(btn)
        
        return btn
    }()

    /// waiting view for footer
    private lazy var waitingView: UIActivityIndicatorView = {
        let wv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        wv.hidden = true
        self.addSubview(wv)
        return wv
    }()
    
    /// a flag that wether operate in funtion observeValueForKeyPath
    private var ignoreThisSizeChange: Bool = false
    
    /// loader的状态
    override  var state: EDLoaderState? {
        didSet { // 根据状态来做事
            
            if oldValue == state  {
                return
            }
            if state == .willLoad {
                print("willLoad")
            } else if state == .free {
                print("free")
            }  else if state == .loading {
                print("loading")
            } else if state == .reset {
                print("reset")
            }
        }
    }
    
    // MARK: Initialiaztion
    override init(frame: CGRect) {
        super.init(frame:  CGRect(x: 0, y: 0, width: ed_screenW, height: loaderHeight))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // MARK: - Private Function
    
    override func loaderWillAddToSrollView() {
        super.loaderWillAddToSrollView()
        // 需要开启新线程才能获取正确的contenInset，原因不明
        dispatch_async(dispatch_get_main_queue()) {
            self.initialSuperViewContentOffsetY = (self.superScrollView?.ed_contentOffsetY())!
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
        
        let contenOffsetY = (superview as! UIScrollView).ed_contentOffsetY()
        
        
        // 如果已经向上滚动的话，直接返回
        if contenOffsetY < footViewWillShowOffsetY {
            return
        }
        
        
        
        // 判断当前loader的状态
        if superScrollView?.dragging == true
        {
            if contenOffsetY > footViewWillShowOffsetY+ed_loadingOffset
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
        footViewWillShowOffsetY = (superScrollView?.ed_ContenSizeH)! - ed_screenH + initialSuperViewContentOffsetY!
        if ignoreThisSizeChange == true {
            ignoreThisSizeChange = false
            return
        }
        
        self.ed_top = (superScrollView?.contentSize.height)!
        
        ignoreThisSizeChange = true
        superScrollView?.ed_ContenSizeH = self.ed_top + loaderHeight
 
    }
    
    
    public override func setupSurface() {
        super.setupSurface()
        footBtn.ed_width = self.ed_width
        footBtn.ed_height = self.ed_height
        footBtn.addTarget(target, action: action!, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: Function
    public override func beginLoading() {
    }
    
    public override func endLoading() {
    }
    
//    public override func loading() -> Bool {
//    }
    
    
    
}
