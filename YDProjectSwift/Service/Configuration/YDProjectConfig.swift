//
//  YDProjectConfig.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/2.
//

import Foundation

private let kUserInfoKey = "userinfo"

/// 存储一些全局的变量
class YDProjectConfig {
    
    static let share = YDProjectConfig()
    init() {
        if let token = UserDefaults.standard.object(forKey: "loginToken") as? String {
            loginToken = token
        }
        if let userinfoStr = UserDefaults.standard.object(forKey: kUserInfoKey) as? String {
            userinfo = userinfoStr
        }
    }
    /// 网络请求使用的token
    var token: String? {
        if let token = loginToken {
            return token
        }
        if let token = initToken {
            return token
        }
        return nil
    }
    
    var userinfo: String? {
        willSet {
            if let str = newValue {
                UserDefaults.standard.set(str, forKey: kUserInfoKey)
                WebViewLocalStorage.addUser("user", user: str)
                UserDefaults.standard.synchronize()
            } else {
                WebViewLocalStorage.removeItem("user")
                WebViewLocalStorage.removeItem("token")
                if UserDefaults.standard.object(forKey: kUserInfoKey) != nil {
                    UserDefaults.standard.removeObject(forKey: kUserInfoKey)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    func updateUserInfo(_ user:AIUserModel?) {
        guard let user = user, let userStr = userinfo else {
            return
        }
        
        if let model = AIUserContainerModel.deserialize(from: userStr) {
            model.user = user
            self.userinfo = model.toJSONString()
        }
    }
    
    var loginToken:String? {
        willSet {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: "loginToken")
                UserDefaults.standard.synchronize()
            } else {
                if UserDefaults.standard.object(forKey: "loginToken") != nil {
                    UserDefaults.standard.removeObject(forKey: "loginToken")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    var netDate:String?
    
    var date:String {
       return ""
    }
    
    var initToken:String?

    var isToken:Bool {
        guard let token = token else {
            return false
        }
        if token.count == 0 {
            return false
        }
        return true
    }
    
    var testcourse:String?
    var systermYear:String?
    var iosPublish:Bool = false
    
    var adversesImageUrl = ""
    var adversesId: Int = 0
    var adversesimageType = ""
    //是否显示任务红点
    var isShowTaskPoint:Bool = false
    
    /// 0：系统自带播放器，1：自定义播放器
    var playerSwitch: Int = 0 {
        didSet {
            //ArtAIPlayerSource.useMSBPlayer = playerSwitch == 1
        }
    }
    
    var weeklySubTitle: String = "得小熊币兑好礼"
    var weeklyJumpUrl: String = ""
    
    //AHA 海报
    var ahaCodeStr: String = ""
    var ahaheadImg: UIImage? = nil
    var ahaAvatarImg: UIImage? = nil
    var ahaShareBgImg: UIImage? = nil
    var ahaCodeImg: UIImage? = nil
    var leftImg: UIImage? = nil
    var rightImg: UIImage? = nil
    var centerImg: UIImage? = nil
    var showImage: UIImage? = nil

    var userDeleteStatus: String = "-1"
    
    /// 用户地区身份
    /// CN_AREA 国内地区
    /// FOREIGN_AREA  国外地区
    /// GAT_AREA 港澳台地区
    var areaType:String = ""
    
    /*
     areaCountry枚举如下：
     CN("中国大陆"),
     HK("中国香港"),
     MO("中国澳门"),
     TW("中国台湾"),
     SG("新加坡"),
     MY("马来西亚");

     国内 ->  CN
     港澳台 -> HK,MO,TW
     东南亚 -> SG,MY
     */
    var areaCountry:String {
        if let areaCountry = UserDefaults.standard.string(forKey: "areaCountry") {
            return areaCountry
        }
        return ""
    }
    //  经度
    var lng:CLLocationDegrees = 0.0
    //  纬度
    var lat:CLLocationDegrees = 0.0
    var isForeignArea: Bool {
        return areaType != "CN_AREA"
    }
    var isForeignAreaCountry: Bool {
        let ac = areaCountry
        if ac.isEmpty {
            return false
        }
        return ac != "CN"
    }
    var experience = ["EXPERIENCE", "SPECIAL"]
    var firstOrder = ["FIRST_ORDER"]
    var renew = ["RENEW"]
    var launchModel: LaunchModel? = nil
    
    //  管理首页弹窗
    var hasShowAlert:Bool = false
    
    var yzIsInit: Bool = false
    
    var isFirstLaunch: Bool {
        get {
            return (UserDefaults.standard.object(forKey: "NotInstall") == nil)
        }
        set {
            if newValue == false {
                UserDefaults.standard.setValue("install", forKey: "NotInstall")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    //MARK: 是否填写过未成年信息
    var isWriteNonageInfo: Bool = false
    
    /// 我的首页有赞商城链接
    var yzStoreUrl: String = ""
}
