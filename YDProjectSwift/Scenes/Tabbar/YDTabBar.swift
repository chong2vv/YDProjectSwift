//
//  YDTabBar.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation

class AITabBar: UITabBar {
    
    var oldSafeAreaInsets = UIEdgeInsets.zero
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if oldSafeAreaInsets != safeAreaInsets {
            oldSafeAreaInsets = safeAreaInsets
            invalidateIntrinsicContentSize()
            superview?.setNeedsLayout()
            superview?.layoutSubviews()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = safeAreaInsets.bottom
            if bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90) {
                size.height += bottomInset
            }
        }
        return size
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var tmp = newValue
            if let superview = superview, tmp.maxY !=
                superview.frame.height {
                tmp.origin.y = superview.frame.height - tmp.height
            }
            super.frame = tmp
        }
    }
    
    override var delegate: UITabBarDelegate? {
        get {
            return super.delegate
        }
        set {
            if let _ = super.delegate {
                //assert(false, "tabbar的delegate被多次设置了")
                return
            }
            super.delegate = newValue
        }
    }
}
