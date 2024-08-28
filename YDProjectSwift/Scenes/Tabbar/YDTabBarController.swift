//
//  YDTabBarController.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation
private let KTabBarItemFont = UIFont.YDFont(fontSize: YDDeviceValue(iPhone: 10, iPad: 11))
private let KTabBarItemDefaultTitleColor = UIColor(hex: "999999")
private let KTabBarItemSelectTitleColor = UIColor(hex: "FF9C00")

private let kItemImageCount: Int = 24

extension UITabBarItem {
    
    fileprivate class func aiItemWith(title:String, defalutImgName:String, selectImgName:String) -> UITabBarItem {
        
        let defaultImg = itemImgWith(name: defalutImgName)
        let selectImg = itemImgWith(name: selectImgName)
        let item = UITabBarItem(title: title, image: defaultImg, selectedImage: selectImg)
        if YDIsiPhone {
            var appendY: CGFloat = 2
            if YDSafeBottom < 1 {
                appendY = -2
            }
            item.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: appendY)
        }
        return item
    }
    
    fileprivate static func itemImgWith(name: String) -> UIImage? {
        if name.count == 0 {
            return nil
        }
        if let img = UIImage(named: name) {
            return img.withRenderingMode(.alwaysOriginal)
        }
        return nil
    }
    
    //MARK: 设置tabbaritem外观
    fileprivate class func AiTabBarItemApperanceSet() {
        self.appearance().setTitleTextAttributes([.foregroundColor : KTabBarItemDefaultTitleColor, .font : KTabBarItemFont], for: .normal)
        self.appearance().setTitleTextAttributes([.foregroundColor : KTabBarItemSelectTitleColor, .font : KTabBarItemFont], for: .selected)
    }
}

private let kRedPointWH: CGFloat = 6
class YDTabBarController: UITabBarController {
    var redView: UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF2C1F")
        let viewWH: CGFloat = kRedPointWH
        view.frame = CGRect(x: 0, y: 0, width: viewWH, height: viewWH)
        view.ai_setCorner(corner: viewWH / 2)
        view.isHidden = true
        return view
    }
    
    /// 存储小红点视图
    lazy var redPointArray = [UIView]()
    var currentSelectIndex = -1
    var feedBackGenertor = UIImpactFeedbackGenerator(style: .light)
    
    var tabbarItems = [UITabBarItem]()
    var animationIms = [UIImageView]()
    var controllers = [YDNavigationController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue(AITabBar(), forKey: "tab" + "Bar")
        self.setUpTabBarController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpTabBarController() {
        
        let home = YDNavigationController(rootViewController: YDHomeViewController())
        let homeItem = UITabBarItem.aiItemWith(title:  "首页", defalutImgName: "tabbar_home_unselect", selectImgName: "tabbar_home_select")
        home.tabBarItem = homeItem
        
        let mine = YDNavigationController(rootViewController: YDMineViewController())
        let mineItem = UITabBarItem.aiItemWith(title:  "我的", defalutImgName: "tabbar_mine_unselect", selectImgName: "tabbar_mine_select")
        mine.tabBarItem = mineItem
        
        tabbarItems.append(contentsOf: [homeItem, mineItem])
        controllers.append(contentsOf: [home, mine])
        self.viewControllers = controllers
        
        self.delegate = self
        
        self.tabBar.tintColor = KTabBarItemSelectTitleColor
        
        UITabBarItem.AiTabBarItemApperanceSet()
        
        //tabbar顶部分割线
        self.setTabbarTopLine()
        
        //MARK: tabbar背景色
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.tabBar.ai_height + YDSafeBottom))
        bgView.backgroundColor = .white
        self.tabBar.insertSubview(bgView, at: 0)
    }
    
    
    //MARK: 设置tabbar顶部分割线
    func setTabbarTopLine() {
        let line = UIView(frame: CGRect(x: 0, y: -kNaviLineHeight, width: kScreenWidth, height: kNaviLineHeight))
        line.backgroundColor = kNaviLineColor
        self.tabBar.insertSubview(line, at: 0)
    }
        
    /// 展示/隐藏tabbaritem上的小红点
    /// - Parameter isShow: true显示
    /// - Parameter index: tabbaritem index
    func showOrHiddenRedPoint(isShow: Bool, index: Int) {
        if index < self.redPointArray.count && index >= 0 {
            let pointView = self.redPointArray[index]
            pointView.isHidden = !isShow
        }
    }
    
    override var selectedIndex: Int {
        didSet {
            selectTabWith(index: selectedIndex, animation: false)
        }
    }
    
    func relseaseSelf() {
        if let vcs = viewControllers, vcs.count > 0 {
            for vc in vcs {
                vc.removeFromParent()
            }
        }
        viewControllers = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension YDTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        playFeedbackGenerator()
        if let index = tabbarItems.firstIndex(of: item) {
//            if index == 3, gUserIsLogin == false {
//                return
//            }
            selectTabWith(index: index)
        }
    }
    
    private func checkIndex(index: Int) -> Bool {
        if index >= 0 && index < tabbarItems.count {
            return true
        }
        return false
    }
    
    private func selectTabWith(index: Int, animation: Bool = true) {
        if index != currentSelectIndex, checkIndex(index: index), animationIms.isEmpty == false {
            if checkIndex(index: currentSelectIndex) {
                let lastAnimationImageView = animationIms[currentSelectIndex]
                lastAnimationImageView.stopAnimating()
                lastAnimationImageView.image = lastAnimationImageView.animationImages?.first
            }

            let currentAnimationImageView = animationIms[index]
            currentAnimationImageView.image = currentAnimationImageView.animationImages?.last
            if animation {
                currentAnimationImageView.startAnimating()
            }
            currentSelectIndex = index
            
            if index == 2 {
                TrackWithEvent()
            }
        }
    }
    
    private func imageViewWith(tabbarItemInfo: YDTabbarItemInfo) -> YDTabbarItemImageView {
        let im = YDTabbarItemImageView()
        im.frame.size = CGSize(width: 36, height: 29)
        var images = [UIImage]()
        let prefixName = tabbarItemInfo.imagePrefix
        let imageCount = max(kItemImageCount, tabbarItemInfo.imageCount)
        if let filePath = Bundle.main.path(forResource: prefixName, ofType: "png") {
            if let image = UIImage(contentsOfFile: filePath) {
                images.append(image)
            }
        }
        for i in 0...imageCount {
            let fileName = prefixName + String(format: "%02d", i)
            if let filePath = Bundle.main.path(forResource: fileName, ofType: "png") {
                if let image = UIImage(contentsOfFile: filePath) {
                    images.append(image)
                }
            }
        }
        im.animationImages = images
        im.animationRepeatCount = 1
        im.animationDuration = 0.02 * TimeInterval(imageCount)
        im.image = im.animationImages?.first
        return im
    }
    
    /// 震动反馈
    func playFeedbackGenerator() {
        feedBackGenertor.impactOccurred()
    }
}

extension YDTabBarController{
    func TrackWithEvent(){
    }
}

private struct YDTabbarItemInfo {
    var imageCount: Int = 24
    var imagePrefix: String = "home_curriculum_000"
}

class YDTabbarItemImageView: UIImageView {}

extension YDTabBarController {
    @objc func updateStoreItem() {
        
    }
}
