

import UIKit

public class EDAutoFootLoader: EDNormalFootLoader {
    
    /// automatic to begin loading when the percentage of footLoader did show, default is 0.8
    public var percentFootLoaderDidShowToLoading: CGFloat = 0.8

    override func contentOffsetDidChange() {
        super.contentOffsetDidChange()
        
        // 如果不在主窗口显示就直接返回
        if window == nil {
            return
        }
        
    
        
        let contenOffsetY = (superview as! UIScrollView).ed_contentOffsetY
        

        /// footLoader已经显示的比值
       let percentFootLoaderDidShow = (contenOffsetY - footLoaderWillShowOffsetY) / loaderHeight

        if percentFootLoaderDidShow >= percentFootLoaderDidShowToLoading
        {
            // ***************
            // 这一步非常关键，防止state重复的在.free和.loading之间来回切换而疯狂调用Selector,当加载完数据使得contentSize 改变的时候,该值将恢复正常
            footLoaderWillShowOffsetY = CGFloat(MAXFLOAT)
            // ***************
            state = .loading
        }
        
    }
}
