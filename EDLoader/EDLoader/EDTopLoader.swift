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
 
    /// 父控件 
    override var superScrollView: UIScrollView? {
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
    
    
    /**
     通过监听偏移来确定loader的状态，从而知道做什么
     
     */
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
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
 

    override public func setupSurface() {
        super.setupSurface()
 
       
    }
    // MARK: - Inner Function
    /**
     调用入口，添加到一个scrollView即可
     
     */
    override func setToScrollView(view: UIScrollView) -> Void {
        super.setToScrollView(view)
        
        // 监听
        setupObserver()
    }
    
    func setupObserver() {
        superScrollView!.addObserver(self, forKeyPath: EDContentOffsetKey, options: [NSKeyValueObservingOptions.New, .Old], context: nil)
        
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
