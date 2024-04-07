//
//  WebViewLocalStorage.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/2.
//

import Foundation
import WebKit

class WebViewLocalStorage:NSObject,WKNavigationDelegate {
    
    private var addItems:[String] = [String]()
    private var removeItems:[String] = [String]()
    private var content:[String:String] = [String:String]()
    static let share = WebViewLocalStorage()
    
    static func removeItem(_ itemName:String?,webView:WKWebView? = nil) {
        if let name = itemName {
            if webView != nil {
                webView?.evaluateJavaScript("localStorage.removeItem('\(name)')", completionHandler: { (res, nil) in
                })
            }
        }
    }
    
    static func addUser(_ itemName:String?,user:String?,webView:WKWebView? = nil) {
        if let name = itemName , let json = user{
            if webView != nil {
                webView?.evaluateJavaScript("localStorage.setItem('\(name)','\(json)')", completionHandler: { (res, nil) in
                    
                })
            }
        }
    }
    
    lazy var webView:WKWebView = {
        let wkConfig = WKWebViewConfiguration()
        wkConfig.applicationNameForUserAgent = userAgent
        wkConfig.processPool = ProgressPool.pool
        let webview = WKWebView(frame: .zero, configuration: wkConfig)
        return webview
    }()
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if addItems.count == 0 {
            for key in removeItems {
                let removeItem = "localStorage.removeItem('\(key)')"
                webView.evaluateJavaScript(removeItem) {[weak self] (res, err) in
                    if res != nil {
                        self?.content.removeValue(forKey: key)
                        if let index = self?.addItems.firstIndex(of: key) {
                            self?.addItems.remove(at: index)
                        }
                    }
                }
            }
            removeItems.removeAll()
            return
        }
        
        for key in addItems {
            if let value = content[key] {
                let addItem = String(format: "localStorage.setItem('%@', '%@')",key,value)
                content.removeValue(forKey: key)
                webView.evaluateJavaScript(addItem) {[weak self] (res, err) in
                    if err != nil {
                        print("setItem is err")
                    } else {
                        print("setItem is success")
                    }
                    if res != nil {
                        self?.content.removeValue(forKey: key)
                        if let index = self?.addItems.firstIndex(of: key) {
                            self?.addItems.remove(at: index)
                        }
                    }
                }
            }
        }
        addItems.removeAll()
    }
    
    func setUA() {
        webView.evaluateJavaScript("navigator.userAgent") { [weak self](result, error) in
            if let ua = result as? String {
                var newUa = ua
                if newUa.contains(appname) == false {
                    if !ua.contains(userAgent) {
                        newUa = ua + "  " + userAgent
                    }
                } else {
                    let uaArray = newUa.components(separatedBy: appname)
                    if let firstPart = uaArray.first {
                        newUa = firstPart + userAgent
                    }
                }
                self?.webView.customUserAgent = newUa
            }
        }
    }
}

