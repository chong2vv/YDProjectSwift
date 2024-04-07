//
//  YDFileManager.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation

private let kOneMB: Double = 1024 * 1024
enum YDSandboxPathType {
    case inDocument
    case inLibraryCache
    
    func getPath() -> String {
        var path = ""
        let homePath = NSHomeDirectory()
        switch self {
        case .inDocument:
            path = homePath + "/Documents/"
            break
        case .inLibraryCache:
            path = homePath + "/Library/Caches/"
            break
        }
        return path
    }
}
class YDFileManager {
    static func createDirectory(dirName: String, sandBoxType: YDSandboxPathType = .inLibraryCache) -> String? {
        let dirPath = sandBoxType.getPath() + dirName + "/"
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: dirPath) == false else {
            return dirPath
        }
        do {
            try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            return dirPath
        } catch {
            return nil
        }
    }
    
    static func dirFilesName(dirPath: String) -> [String]? {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: dirPath) else {
            LogInfo("AIFileManager \(dirPath) 不存在")
            return nil
        }
        do {
            return try fileManager.contentsOfDirectory(atPath: dirPath)
        } catch {
            LogError("AIFileManager error:\(error)")
        }
        return nil
    }
    
    /// 返回目录下文件大小MB（不包含忽略文件）
    /// - Parameter dirPath: 目录
    /// - Parameter ignorelist: 忽略文件列表
    static func dirFilesSize(dirPath: String, ignorelist: [String]? = nil) -> Double {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: dirPath) else {
            LogInfo("AIFileManager \(dirPath) 不存在")
            return 0
        }
        var fileSize: Double = 0
        if let fileNameList = self.dirFilesName(dirPath: dirPath), fileNameList.isEmpty == false {
            for fileName in fileNameList {
                if let iglist = ignorelist, iglist.contains(fileName) {
                    continue
                }
                let path = dirPath + fileName
                do {
                    let fileinfo = try fileManager.attributesOfItem(atPath: path)
                    if let size = fileinfo[FileAttributeKey.size] as? Double {
                        fileSize = fileSize + size
                    }
                } catch {
                    LogError("\(error)")
                }
            }
        }
        return fileSize / kOneMB
    }
    
    static func delDirFiles(dirPath: String, ignorelist: [String]? = nil) {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: dirPath) else {
            LogInfo("AIFileManager \(dirPath) 不存在")
            return
        }
        if let fileNameList = self.dirFilesName(dirPath: dirPath), fileNameList.isEmpty == false {
            for fileName in fileNameList {
                if let iglist = ignorelist, iglist.contains(fileName) {
                    continue
                }
                let path = dirPath + fileName
                if fileManager.isDeletableFile(atPath: path) {
                    do {
                        try fileManager.removeItem(atPath: path)
                        LogInfo("AIFileManager:\(fileName)删除成功")
                    } catch {
                        LogError("\(error)")
                    }
                }
            }
        }
    }
    
    /// 删除文件
    /// - Parameter path: 文件路径
    static func delfileWith(path: String) -> Bool {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            LogInfo("AIFileManager \(path) 不存在")
            return false
        }
        if fileManager.isDeletableFile(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
                return true
            } catch {
                LogError("\(error)")
            }
        }
        return false
    }
}
