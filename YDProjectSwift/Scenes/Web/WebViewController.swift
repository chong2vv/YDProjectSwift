//
//  WebViewController.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/8/28.
//

import Foundation
import WebKit

class WebViewController: UIViewController,YDCustomNaviProtocol,WKUIDelegate,WKNavigationDelegate,RouterProtocol {
    
    private var _urlStr: String? = nil
    public var urlStr: String? {
        get {
            return _urlStr
        }
        set {
            if let value = newValue, let string = value.removingPercentEncoding {
                let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                _urlStr = str.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            }
        }
    }
    
    var data:[String:Any]? = nil
    
    lazy var webView = { () -> WKWebView in
        let wkConfig = WKWebViewConfiguration()
        wkConfig.processPool = ProgressPool.pool
        wkConfig.applicationNameForUserAgent = userAgent
        wkConfig.allowsInlineMediaPlayback = true
        // for 直播
        if #available(iOS 10.0, *) {
            wkConfig.mediaTypesRequiringUserActionForPlayback = []
        } else {
            wkConfig.mediaPlaybackRequiresUserAction = false
        }
     
        if UIDevice.current.cpuBits < 64 {
            wkConfig.suppressesIncrementalRendering = true
            wkConfig.websiteDataStore = WKWebsiteDataStore.default()
        } else {
            wkConfig.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        wkConfig.preferences = preferences
        
        let webview = WKWebView(frame: .zero, configuration: wkConfig)
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.allowsBackForwardNavigationGestures = false
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
        }
        return webview
    }()
    
    
    func ydNavigationBackItemClick() {
        onBackItemClicked()
    }
    
    convenience init(_ title: String? = nil, urlStr: String? = nil) {
        self.init()
        self.urlStr = urlStr
        self.title = title
    }
    
    static func create(_ params: [AnyHashable : Any]?) -> RouterProtocol? {
        let vc = WebViewController()
        if let urlStr = params?["url"] as? String {
            vc.urlStr = urlStr
        }
        if let data = params?["data"] as? [String:Any] {
            vc.data = data
        }
        return vc
    }
    
    func onBackItemClicked(){
        
        if webView.canGoBack {
            webView.goBack()
            return
        }
        navigationController?.popViewController(animated: true)
    }
}
