//
//  YDNetArchive.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation

class YDNetArchive: YDArchive {
    
    override class func dirPath() -> String? {
        return YDFileManager.createDirectory(dirName: "YDNetCache")
    }
}
