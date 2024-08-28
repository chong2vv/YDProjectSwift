//
//  YDNavigationController.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation
import UIKit

let kBlackColor = UIColor(hex: "#222222")
let kNaviTitleFont = UIFont.YDBoldFont(fontSize: 18)
let KNaviTitleColor = kBlackColor
let kNaviLineHeight: CGFloat = 0.5//导航条底部分割线高度
let kNaviLineColor = UIColor(hex: "#E6E6E6")//导航条底部分割线颜色

/// 如果需要自己处理导航条backItem点击逻辑，需要遵守协议并自己实现backItem点击方法；
protocol YDCustomNaviProtocol {
    /// 自定义返回按钮点击事件
    func ydNavigationBackItemClick()
}

class YDNavigationController: UINavigationController {
    
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "black_left_arrow"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        btn.addTarget(self, action: #selector(backItemClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var naviBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = kNaviLineColor
        return view
    }()
    
    /// 不统一设置返回按钮页面
    lazy var notSetBackItemList: [String] = {
        return ["ZCChatController", "ZCUILeaveMessageController"]
    }()
    
    /// 禁用侧滑手势页面
    lazy var closePopGestureList: [String] = {
        return [String]()
    }()
    
    fileprivate var popGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    var isAnimation: Bool = false
    
    /// 允许push相同页面
    var allowPushSamePage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavi()
    }
    
    func setUpNavi() {
        self.delegate = self
        self.popGestureRecognizerDelegate = interactivePopGestureRecognizer?.delegate
        self.setUpAppearance()
    }
    
    //MARK: 定制导航条外观
    func setUpAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        self.navigationBar.tintColor = kBlackColor
        self.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 15.0, *) {
            let newApperance = UINavigationBarAppearance()
            newApperance.backgroundColor = .white
            newApperance.shadowImage = UIImage()
            newApperance.shadowColor = .clear
            newApperance.titleTextAttributes = [.foregroundColor : KNaviTitleColor, .font : kNaviTitleFont]
            navigationBar.scrollEdgeAppearance = newApperance
            navigationBar.standardAppearance = newApperance
            
        } else {
            self.navigationBar.titleTextAttributes = [.foregroundColor : KNaviTitleColor, .font : kNaviTitleFont]
            self.navigationBar.addSubview(self.naviBottomLine)
            self.naviBottomLine.snp.makeConstraints { (make) in
                make.height.equalTo(kNaviLineHeight)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //push动画中不允许push
        if isAnimation {
            LogDebug("正在push动画过程中不允许push")
            return
        }
        
       
        //不允许push相同页面（allowPushSamePage开关打开时忽略）
        if let topVC = navigationController?.topViewController, topVC.isMember(of: type(of: viewController)), allowPushSamePage == false {
            LogDebug("not allowed push same page!!!")
            return
        }
        
        //允许push相同页面属性每次都需要设置
        if allowPushSamePage {
            allowPushSamePage = false
        }
        
        
        //隐藏tabbar
        if self.viewControllers.count >= 1, viewController.hidesBottomBarWhenPushed == false {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        //设置返回按钮
        if self.viewControllers.count > 0, self.isNeedSetBackItem(vc: viewController) {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "black_left_arrow"), style: .plain, target: self, action: #selector(backItemClick))
        }
        
        //延时设置isAnimation状态
        if animated {
            isAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isAnimation = false
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK: 返回按钮点击事件
    @objc func backItemClick() {
        if self.viewControllers.count > 1 {
            if let topVC = self.topViewController as? YDCustomNaviProtocol {
                topVC.ydNavigationBackItemClick()
            } else {
                super.popViewController(animated: true)
            }
        }
    }
    
    //MARK: 判断将要push进入的控制器是否需要设置backItem
    func isNeedSetBackItem(vc: UIViewController) -> Bool {
        let vcName = vc.ydClassName
        if self.notSetBackItemList.contains(vcName) {
            return false
        }
        return true
    }
    
    //MARK: 判断页面是否需要关闭侧滑手势
    func isNeedClosePopGesture(vc: UIViewController) -> Bool {
        let vcName = vc.ydClassName
        if self.closePopGestureList.contains(vcName) {
            return true
        }
        return false
    }
}

extension YDNavigationController: UINavigationControllerDelegate {
    //MARK: 处理自定义backitem后侧滑手势无效问题
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == viewControllers[0] || self.isNeedClosePopGesture(vc: viewController) {
            self.interactivePopGestureRecognizer?.delegate = self.popGestureRecognizerDelegate
        } else {
            self.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}
