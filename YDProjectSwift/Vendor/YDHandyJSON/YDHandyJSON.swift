//
//  YDHandyJSON.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation
import HandyJSON

public protocol YDHandyJSONEnum: HandyJSONEnum {}
public protocol YDHandyJSON : HandyJSON {}

public extension YDHandyJSON {
    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    static func ydDeserialize(from dict: NSDictionary?, designatedPath: String? = nil) -> Self? {
        return deserialize(from: dict, designatedPath: designatedPath)
    }

    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    static func ydDeserialize(from dict: [String: Any]?, designatedPath: String? = nil) -> Self? {
        return deserialize(from: dict, designatedPath: designatedPath)
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    static func ydDeserialize(from json: String?, designatedPath: String? = nil) -> Self? {
        return deserialize(from: json, designatedPath: designatedPath)
    }
    
    func ydToJSON() -> [String: Any]? {
        return self.toJSON()
    }

    func ydToJSONString(prettyPrint: Bool = false) -> String? {
        return self.toJSONString(prettyPrint:prettyPrint)
    }
}

public extension Array where Element: YDHandyJSON {

    /// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    static func artDeserialize(from json: String?, designatedPath: String? = nil) -> [Element?]? {
        return deserialize(from: json, designatedPath: designatedPath)
    }

    /// deserialize model array from NSArray
    static func artDeserialize(from array: NSArray?) -> [Element?]? {
        return deserialize(from: array)
    }

    /// deserialize model array from array
    static func artDeserialize(from array: [Any]?) -> [Element?]? {
        return deserialize(from: array)
    }
}
