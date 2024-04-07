//
//  YDArchive.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation
import UIKit

class YDArchive {
    /// 归档的文件夹目录
    class func dirPath() -> String? {
        return YDFileManager.createDirectory(dirName: "YDDefaultCache", sandBoxType: .inDocument)
    }
    
    /// 返回归档文件大小 单位: MB（不包括ignorelist里的文件）
    /// - Parameter ignorelist: 葫芦哦文件列表
    static func cacheSize(ignorelist: [String]?) -> Double {
        if let dirpath = self.dirPath() {
            return YDFileManager.dirFilesSize(dirPath: dirpath, ignorelist: self.verifyKeyList(keylist: ignorelist))
        }
        return 0
    }
    
    /// 清除归档的缓存
    /// - Parameter ignorelist: 忽略文件列表
    static func cleanCache(ignorelist: [String]?) {
        if let dirpath = self.dirPath() {
            YDFileManager.delDirFiles(dirPath: dirpath, ignorelist: self.verifyKeyList(keylist: ignorelist))
        }
    }
    
    /// 文件名称校验（去除特殊字符）
    /// - Parameter key: 原始文件名
    static func keyVerify(key: String) -> String {
        guard key.isEmpty == false else {
            return ""
        }
        let keys = key.components(separatedBy: "/")
        var cacheKey = ""
        for k in keys {
            cacheKey = cacheKey + k
        }
        return cacheKey
    }
  
    /// 对缓存清除白名单做校验（已处理："/"）
    /// - Parameter keylist: 需要被处理的键值列表
    static func verifyKeyList(keylist: [String]?) -> [String]? {
        if let whitelist = keylist, whitelist.count > 0 {
            var list = [String]()
            for filename in whitelist {
                list.append(self.keyVerify(key: filename))
            }
            return list
        }
        return nil
    }
    
    /// 得到缓存路径 dirPath + key
    /// - Parameter forKey: key（文件名）
    static func path(forKey: String) -> String? {
        let key = self.keyVerify(key: forKey)
        if let dir = self.dirPath(), key.count > 0 {
            return dir + key
        }
        return nil
    }
    
    class func archive(data: Any?, forKey: String) {
        if let jsonData = data, let path = self.path(forKey: forKey) {
            if #available(iOS 11.0, *) {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: jsonData, requiringSecureCoding: true)
                    do {
                        try data.write(to: URL(fileURLWithPath: path))
                    } catch {
                        print(error)
                    }
                } catch {
                    print(error)
                }
            } else {
                let isSuccess = NSKeyedArchiver.archiveRootObject(jsonData, toFile: path)
                if isSuccess == false {
                    print("key:\(forKey) 归档失败")
                }
            }
        }
    }
    
    /// 解归档
    /// - Parameter forKey: key
    class func unarchive(forKey: String) -> Any? {
        if let path = self.path(forKey: forKey) {
            let isExist = FileManager.default.fileExists(atPath: path)
            if !isExist {
                return nil
            }
            if #available( iOS 11.0, *) {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    do {
                        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                    } catch {
                        print(error)
                    }
                } catch {
                    print(error)
                }
            } else {
                return NSKeyedUnarchiver.unarchiveObject(withFile: path)
            }
        }
        return nil
    }
    
    class func remove(forKey: String) -> Bool {
        if let path = self.path(forKey: forKey) {
            return YDFileManager.delfileWith(path: path)
        }
        return false
    }

}
