//
//  EDFootLoader.swift
//  EDLoader
//
//  Created by edoohwang on 7/30/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import UIKit

public class EDFootLoader: EDLoader {

    /// bottom button for superView
    private lazy var footBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.ed_width = ed_screenW
        btn.ed_height = loaderHeight
        btn.titleLabel?.text = "点击或者上拉加载更多"
        return btn
    }()

    /// waiting view for footer
    private lazy var waitingView: UIActivityIndicatorView = {
        
        let wv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        wv.hidden = true
        self.addSubview(wv)
        return wv
    }()
}
