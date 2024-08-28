//
//  Foundation+YD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation
func YDLocalizeString(key: String, tableName: String = "YDProjectLocalizable", comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, comment: comment)
}

extension Dictionary {
    
    func jsonString() -> String? {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: [])
                let jsonStr = String(data: data, encoding: .utf8)
                return jsonStr
                
            } catch  {
                LogInfo(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {
    func aiHeightWith(font: UIFont, width: CGFloat, lineSpace: CGFloat = 0) -> CGFloat {
        guard self.isEmpty == false else {
            return 0.0
        }
        let str = self as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        let font = font
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let height = str.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height
        return ceil(height)
    }
    
    func aiattributedStringWith(font: UIFont, lineSpace: CGFloat = 0) -> NSMutableAttributedString {
        let attriString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        let font = font
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        attriString.setAttributes(attributes, range: NSRange(location: 0, length: self.count))
        return attriString
    }
    
    func aiReplaceEmoji(withChar: Character) -> String {
        return String(self.map({ (char) -> Character in
            if char.isEmoji() {
                return withChar
            }
            return char
        }))
    }
    
    func jsonObject() -> [String:Any]? {
        let str = self.removingPercentEncoding
        if let data = str?.data(using: .utf8) {
            do {
                let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                return dic
            }
            catch {
                print(error)
            }
        }
        return nil
    }
}

extension Character {
    fileprivate func isEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
                0x00A0...0x00AF,
                0x2030...0x204F,
                0x2120...0x213F,
                0x2190...0x21AF,
                0x2310...0x329F,
                0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
}

func YDLog(_ input: Any..., file: String = #file, function: String = #function, line:Int = #line) {
    #if DEBUG
    var fileName = file
    let fileNameArray = file.components(separatedBy: "/")
    if let f = fileNameArray.last {
        fileName = f
    }
    LogInfo("<file: \(fileName)> <func: \(function)> <line: \(line)>: \(input)")
    #else
    #endif
}

private var currentTime: Double = 0
func StartTimeLog() {
    currentTime = CFAbsoluteTimeGetCurrent()
}

func TimeLog(_ input: Any...) {
    #if DEBUG
    let time = String(format: "%.2f", CFAbsoluteTimeGetCurrent() - currentTime)
    currentTime = CFAbsoluteTimeGetCurrent()
    print("<time: \(time)> \(input)")
    #else
    #endif
}

extension String {
    func urlEncoded() -> String {
         let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
             .urlQueryAllowed)
         return encodeUrlString ?? ""
     }
}
