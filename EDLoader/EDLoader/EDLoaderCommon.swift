//
//  EDRefreshCommon.swift
//  EDWBLoaction
//
//  Created by edoohwang on 7/27/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//


import UIKit
let EDContentOffsetKey = "contentOffset"
let EDContentSizeKey = "contentSize"
var memberHeadLoaderKey: UInt8 = 0//"memberHeadLoaderKey"
var memberFootLoaderKey: UInt8 = 0//"memberFootLoaderKey"


/// 触发刷新的拖动偏移量
let ed_loadingOffset: CGFloat = 100

/// Loader高度
let loaderHeight: CGFloat = 50

let ed_screenW: CGFloat = UIScreen.mainScreen().bounds.width

let ed_screenH: CGFloat = UIScreen.mainScreen().bounds.height

let ed_animationDurution: NSTimeInterval = 0.25

