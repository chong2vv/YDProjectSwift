//
//  YDViewController.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/8/28.
//

import Foundation

class YDViewController: UIViewController {
    
    /// 消失时是否隐藏导航条，在 Push/Present 到无导航栏页面时设置为 true
    public var navigationBarHiddenWhenDisappear = false
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //
        if let nc = navigationController, !navigationBarHiddenWhenDisappear {
            nc.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
