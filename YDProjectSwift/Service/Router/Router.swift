//
//  Router.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation

let kRouterPrefix: String = "ydclass"

protocol RouterProtocol {
    static func create(_ params:[AnyHashable:Any]?) -> RouterProtocol?
}

class Router {
    static private var pages = [String:String]()
    static let share = Router()
    private var url: URL? = nil
    private var urlStr: String? = nil
    
    var isCanPush:Bool = false {
        didSet {
            if isCanPush {
                Router.request(self.url, urlStr: self.urlStr)
            }
        }
    }
    
    static func routerWith(urlStr: String?) {
        if let str = urlStr, str.isEmpty == false {
            let prefixStr = "ydclass://project?"
            if str.hasPrefix(prefixStr) {
                if let paUrl = str.components(separatedBy: prefixStr).last {
                    var handleUrl = paUrl
                    var json: String? = nil
                    if paUrl.contains("json=") {
                        let list = paUrl.components(separatedBy: "json=")
                        if let firstUrl = list.first {
                            handleUrl = firstUrl
                        }
                        
                        if let lastUrl = list.last {
                            json = lastUrl
                        }
                    }
                    
                    let list = handleUrl.components(separatedBy: "&")
                    var parmerDic = [String: Any]()
                    for item in list {
                        let itemList = item.components(separatedBy: "=")
                        if let key = itemList.first , let value = itemList.last {
                            if key.count > 0 {
                                parmerDic[key] = value
                            }
                        }
                    }
                    
                    var pageName = ""
                    if let method = parmerDic["method"] as? String, method.count > 0 {
                        pageName = method
                    }
                    
                    if let page = parmerDic["page"] as? String, page.count > 0 {
                        pageName = page
                    }
                    
                    if let jsonContent = json {
                        parmerDic.updateValue(jsonContent, forKey: "json")
                    }
                    
                    Router.share.onContoller(pageName, params: parmerDic)
                }
            } else if str.hasPrefix("http") {
                openWebPage(url: str)
            }
        }
    }
    
    //MARK: 打开一个web页面
    private static func openWebPage(url: String) {
        if url.hasPrefix("http") {
            let web = WebViewController(urlStr: url)
            Router.share.onNextPage(web)
        }
    }
    
    private static func needLoginWith(url: URL?, urlStr: String? = nil) -> Bool {
        if let str = url?.absoluteString {
            return checkUrlForLogin(urlStr: str)
        }
        
        if let str = urlStr {
            return checkUrlForLogin(urlStr: str)
        }
        return true
    }
    
    static func request(_ url: URL? = nil, isPresent:Bool = false, controller:UIViewController? = nil, needLogin: Bool = true, urlStr: String? = nil) {
        
        if url == nil && urlStr == nil {
            return
        }
        
        var isNeedLogin = self.needLoginWith(url: url, urlStr: urlStr)
        if needLogin == false {
            isNeedLogin = false
        }
        
        YDLog("路由：url = \(urlStr ?? "")")
        
        if share.isCanPush == false {
            share.url = url
            share.urlStr = urlStr
            return
        } else {
            share.url = nil
            share.urlStr = nil
        }
        
        if let vc = Router.share.currentController {
            if isNeedLogin {
                self.newHandleUrl(url, urlStr: urlStr)
            } else {
                self.newHandleUrl(url, urlStr: urlStr)
            }
        }
    }
    
    private static func newHandleUrl(_ url: URL?, urlStr: String? = nil) {
        if let _ = url {
            share.handlerUrl(url)
        } else if let _ = urlStr {
            routerWith(urlStr: urlStr)
        }
    }
    
    private func queryParseWith(urlStr: String) -> [String: Any]? {
        let decodeUrlStr = urlStr.removingPercentEncoding ?? ""
        if let urlComponents1 = URLComponents(string: decodeUrlStr) {
            return queryParseWithURLComponents(urlComponents: urlComponents1)
        }
        return nil
    }
    
    private func queryParseWithURLComponents(urlComponents: URLComponents) -> [String: Any]? {
        let scheme = urlComponents.scheme ?? ""
        let host = urlComponents.host ?? ""
        let path = urlComponents.path
        YDLog("scheme:\(scheme) host:\(host) path:\(path)")
        var parameter = [String: Any]()
        if let queryItems = urlComponents.queryItems {
            for query in queryItems {
                parameter.updateValue(query.value?.removingPercentEncoding ?? "", forKey: query.name)
            }
        }
        return parameter
    }
    
    private func handlerUrl(_ url:URL?) {
        guard let url = url else {
            return
        }
        YDLog("\(url.absoluteString)")
        if url.absoluteString.hasPrefix("artaiclass") {
            var params = [String:Any]()
            if let npa = queryParseWith(urlStr: url.absoluteString) {
                params = npa
            } else if let ppa = url.queryParse() {
                params = ppa
            }
            guard let type = params["type"] as? String else {
                return
            }
            switch type {
            case "open":
                if let page = params["page"] as? String {
                    if page == "webview" {
                        if let jsonStr = params["json"] as? String,let data = jsonStr.data(using: .utf8) {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                                var nparams = json
                                Router.share.onContoller(page, params: nparams)
                            }
                        }
                        return
                    }
                    
                    if page == "browser" {
                        if let jsonStr = params["json"] as? String,let data = jsonStr.data(using: .utf8) {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                                if let url = json["url"] as? String {
                                    Router.request(URL(string: url))
                                }
                            }
                        }
                        return
                    }
                    
                    var newParams = [String:Any]()
                    for (key,value) in params {
                        if key != "page" && key != "type" {
                            newParams[key] = value
                        }
                    }
                    Router.share.onContoller(params["page"] as? String, params:newParams)
                }
            case "fun":
                if let method = params["method"] as? String {
                    if method == "webview" {
                        if let jsonStr = params["json"] as? String,let data = jsonStr.data(using: .utf8) {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                                var nparams = json
                                Router.share.onContoller(method, params: nparams)
                            }
                        }
                        return
                    }
                    
                    if method == "browser" {
                        if let jsonStr = params["json"] as? String,let data = jsonStr.data(using: .utf8) {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                                if let url = json["url"] as? String {
                                    Router.request(URL(string: url))
                                }
                            }
                        }
                        return
                    }
                    
                    var newParams = [String:Any]()
                    for (key,value) in params {
                        if key != "page" && key != "type" {
                            newParams[key] = value
                        }
                    }
                    Router.share.onContoller(method, params:newParams)
                }
            default:
                return
            }
        } else {
            Router.openWebPage(url: url.absoluteString)
        }
    }
    
    var currentController:UIViewController? {
        let rootVC = getRootController()
        return getTopController(rootVC)
    }
    
    var tabBarController:UITabBarController? {
        if let rootVC = getRootController() as? UITabBarController {
            return rootVC
        }
        return nil
    }
    
    
    private func getTopController(_ controller:UIViewController? = nil) -> UIViewController? {
        guard let vc = controller else { return nil }
        if let presentVC = vc.presentedViewController {
            return getTopController(presentVC)
        } else if let tabVC = vc as? UITabBarController {
            return getTopController(tabVC.selectedViewController)
        } else if let nav = vc as? UINavigationController {
            return getTopController(nav.visibleViewController)
        } else {
            return vc
        }
    }
    
    private func getRootController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        if let vc = window?.rootViewController {
            return vc
        }
        return nil
    }
    
    // 跳转controller
    public func onContoller(_ page:String?,params:[String:Any]) {
        guard let page = page  else {
            return
        }
        if page == "browser" {
            if let jsonStr = params["json"] as? String, let jsonDic = jsonStr.jsonObject() {
                if let url = jsonDic["url"] as? String {
                    Router.openWebPage(url: url)
                }
            }
            return
        }
        
        if page == "storeview" {
            currentController?.navigationController?.popToRootViewController(animated: false)
            if let index = tabBarController?.selectedIndex {
                if index == 3 {
                    return
                }
            }
            onSelectController(3)
            return
        }
        
        guard let projectName = Bundle.main.infoDictionary?["CFBundleName"] as? String  else {
            return
        }
        guard let vcname = Router.pages[page] else {
            return
        }
        
        if let any = NSClassFromString(projectName + "." + vcname) as? RouterProtocol.Type {
            if let vc = any.create(params) as? UIViewController {
                onNextPage(vc)
            }
        }
    }
    
    private func onNextPage(_ toController:UIViewController,fromController:UIViewController? = nil,isPresnet:Bool = false)
    {
        var fromVC = fromController
        if fromVC == nil {
            fromVC = currentController
        }
        if fromVC?.navigationController == nil {
            toController.modalPresentationStyle =  .fullScreen
            fromVC?.present(toController, animated: true, completion: nil)
            return
        }
        if let vc = fromVC as? YDViewController {
            vc.navigationBarHiddenWhenDisappear = false
        }
        if isPresnet {
            toController.modalPresentationStyle =  .fullScreen
            fromVC?.present(toController, animated: true, completion: nil)
        } else {
            //            toController.modalPresentationStyle =  .fullScreen
            if let navi = fromVC?.navigationController, let aiNavi = navi as? YDNavigationController {
                aiNavi.allowPushSamePage = true
            }
            fromVC?.ydPushToVC(toVC: toController)
            //cleanCommonTypeOfController(toController)
        }
    }
    
    private func cleanCommonTypeOfController(_ toController:UIViewController?) {
        guard let toController = toController else { return }
        if let viewControllers = toController.navigationController?.viewControllers {
            if viewControllers.count > 2 {
                let vc = viewControllers[viewControllers.count-2]
                if vc.self == toController.self {
                    toController.navigationController?.viewControllers.remove(at: viewControllers.count-2)
                }
            }
        }
    }
    
    private func onSelectController (_ index:Int) {
        guard let tabVC = tabBarController else { return}
        tabVC.selectedIndex = index
    }
    
    private func onLogin() {
        
    }
    
    func exit(_ animate:Bool = false) {
        if currentController?.presentedViewController != nil {
            currentController?.dismiss(animated: animate, completion: { [weak self] in
                guard let self = self else {return}
                self.exit(animate)
            })
            return
        }
        if let count = currentController?.navigationController?.viewControllers.count {
            if count > 1 {
                currentController?.navigationController?.popToRootViewController(animated: animate)
                exit(animate)
            }
        }
    }
    
    static func exit(_ animate:Bool = false) {
        Router.share.exit(animate)
    }
}

extension Router {
    static func initPages(_ sourse:[String:String]) {
        Router.pages = sourse
    }
    
    static func initPages(_ plistname:String) {
        let pathName = plistname
        guard let path =  Bundle.main.path(forResource: pathName, ofType: nil) else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        if let params = NSDictionary(contentsOf: url) as? [String:String] {
            Router.pages = params
        }
    }
    
    static func updateOpenState(_ state: Bool) {
        LogError("updateOpenState \(state)")
        Router.share.isCanPush = state
    }
}

