//
//  YDAPI.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation
import Moya

enum YDAPI {
    case home_v1_config_appInit(_ params:[String:Any])
    case other_url(_ params:[String:Any])
}

extension YDAPI: YDNetworkTargetType {
    var requestTimeOut: Double {
        switch self {
        case .home_v1_config_appInit:
            return 2
        default:
            return 10
        }
    }
    
    var baseURL: URL {
        var baseUrl = gBaseURL
        switch self {
        case .other_url:
            baseUrl = gOutURL
        default:
            baseUrl = gBaseURL
        }
        return URL.init(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .home_v1_config_appInit:
            return "/home/v1/config/init"
        case .other_url:
            return "/other/url"
        }
    }
    
    var method: YDMethod {
        switch self {
        case .home_v1_config_appInit
            : return .get
        case .other_url:
            return .put
        default:
            return .post
        }
    }
    
    //    这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    //    该条请API求的方式,把参数之类的传进来
    var task: YDTask {
        switch self {
        case .home_v1_config_appInit(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .other_url(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = [String: String]()
        if let token = YDProjectConfig.share.token, token.count > 0 {
            header.updateValue(token, forKey: "token")
            header.updateValue(token, forKey: "Authorization")
        }
        header["appname"] = appname
        header["appversion"] = appversion
        header["buildcode"] = buildCode
        header["systermVersion"] = systemVersion
        header["devicemodel"] = deviceName
        header["devicetype"] = deviceModel
        header["deviceid"] = deviceId
        return header
    }
}

