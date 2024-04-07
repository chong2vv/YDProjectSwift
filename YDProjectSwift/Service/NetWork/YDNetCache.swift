//
//  YDNetCache.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation

protocol YDNetCacheProtocol {
    
    /// 保存网络数据
    /// - Parameter path: 接口路径（缓存标识）
    /// - Parameter jsonData: 服务端返回的数据
    func saveWith(path: String, jsonData: Any?)
    
    /// 读取缓存
    /// - Parameter path: 接口路径
    func readWith(path: String) -> Any?
    
    /// 获取缓存大小
    func cacheSize() -> Double
    
    /// 清理缓存
    func cleanCache()
    
    /// 清理所有缓存（包括被忽略的文件）
    func cleanAllCache()
}

extension YDNetCacheProtocol {
    /// 忽略文件列表（被忽略的文件不会计算大小、调用cleanCache也不会被清理）
    func ignorelist() -> [String]? {
        return nil
    }
}

class YDNetCache: YDNetCacheProtocol {
   
    func saveWith(path: String, jsonData: Any?) {
        if path.isEmpty == false {
            YDNetArchive.archive(data: jsonData, forKey: path)
        }
    }
    
    func readWith(path: String) -> Any? {
        if path.isEmpty == false {
            return YDNetArchive.unarchive(forKey: path)
        }
        return nil
    }
    
    func cacheSize() -> Double {
        return YDNetArchive.cacheSize(ignorelist: self.ignorelist())
    }
    
    func cleanCache() {
        YDNetArchive.cleanCache(ignorelist: self.ignorelist())
    }
    
    func cleanAllCache() {
        YDNetArchive.cleanCache(ignorelist: nil)
    }
}
