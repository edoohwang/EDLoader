//
//  EDNormalFootLoader.swift
//  EDLoader
//
//  Created by edoohwang on 7/31/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import UIKit

public class EDNormalFootLoader: EDFootLoader {
    
    // MARK: Member
    /// bottom button for superView
    private lazy var footBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        
        
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.setTitle("点击或者上拉加载更多", forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(footBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
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
    
    /// loader的状态
    override  var state: EDLoaderState? {
        didSet { // 根据状态来做事
            
         
            
            if oldValue == state  {
                return
            }
            if state == .willLoad {
                footBtn.setTitle("释放即可刷新", forState: UIControlState.Normal)
            } else if state == .free {
                footBtn.hidden = false
                waitingView.hidden = true
                waitingView.stopAnimating()
                footBtn.setTitle("点击或者上拉加载更多", forState: UIControlState.Normal)
            }  else if state == .loading {
                
                setNeedsDisplay()
                
                footBtn.hidden = true
                waitingView.hidden = false
                waitingView.startAnimating()
                
                target?.performSelector(action!)
                
            }
        }
    }
    
    

    
   // MARK: - Private Function
    public override func setupSurface() {
        super.setupSurface()
        
        footBtn.ed_width = self.ed_width
        footBtn.ed_height = self.ed_height
        
        waitingView.ed_center_x = self.ed_width/2
        waitingView.ed_center_y = self.ed_height/2
    }
   // MARK: - Function
    public override func noMoreData() {
        footBtn.setTitle("没有更多数据", forState: UIControlState.Normal)
        // 不能再点击刷新，但是上拉仍然可以刷新
        footBtn.userInteractionEnabled = false
    }
    
    public override func endLoading() {
        
        state = .free
        // 如果加载之后contentsize的高度没有变化，则提示没有更多数据,并且禁止点击加载
        if lastLoadedcontentSizeH != nil && lastLoadedcontentSizeH == superScrollView?.ed_contentSizeH {
            noMoreData()
            footBtn.userInteractionEnabled = false
        } else {
            footBtn.userInteractionEnabled = true
        }
        
        lastLoadedcontentSizeH = superScrollView?.ed_contentSizeH
        
    }


}
