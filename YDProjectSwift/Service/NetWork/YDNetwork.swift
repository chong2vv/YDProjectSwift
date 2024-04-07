//
//  YDNetwork.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation
@_exported import Alamofire
@_exported import HandyJSON

private let kStatusOK = "OK"
private let kDefaultError = "加载失败，请重试"
private let kSuccessCode: Int = 0
let kNetErrorTimeOut = "The request timed out"
private let kACCESS_DENIED = "ACCESS_DENIED"
private let kNetWorkTag = "NetWork"

enum YDNetErrorCode: Int {
    case responseEmpty = -9001//服务端返回数据为空
    case notJsonDicError = -9002//返回的不是json字典
    case notJsonError = -9003//服务端返回的不是json数据
    case dataDecoderError = -9004//未知错误
    case unkonwnError = -9000//未知错误
}

enum YDNetResult<T> {
    case success(T)
    case failure(YDNetError?)
}

public struct YDNetError: CustomStringConvertible {
    var status = ""
    var message: String?
    var code = 0
    
    public var description: String {
        return "[YDNetError] code: \(code) status: \(status) message:\(message ?? kDefaultError)"
    }
    
    static func errorWith(error: NSError) -> YDNetError {
        var errorDes = error.localizedDescription
        let code = error.code
        if code == 6 {
            errorDes = kNetErrorTimeOut
        }
        return YDNetError(status: "request error", message: errorDes, code: code)
    }
    
    static func defaultError(errorMsg: String = kDefaultError) -> YDNetError {
        return YDNetError(status: "unknown", message: errorMsg, code: YDNetErrorCode.unkonwnError.rawValue)
    }
    
    /// 数据解析失败错误
    static func decoderError() -> YDNetError {
        return YDNetError(status: "error", message: "data decoder failure", code: YDNetErrorCode.dataDecoderError.rawValue)
    }
    
    func nserror() -> NSError {
        return NSError(domain: "", code: code, userInfo: ["status": status, "errorMsg": message ?? ""])
    }
}

class YDNotDecode: YDHandyJSON {
    required init() {}
}

class YDNetResponse<Element: YDHandyJSON>: YDHandyJSON, CustomStringConvertible {
    var code = YDNetErrorCode.unkonwnError.rawValue
    var errors: String?
    var status: String = ""
    var payload: Any? = nil
    var model: Element?
    var modelArray: [Element]?
    var jsonData: [String: Any]? = nil
    
    func decode() {
        self.code = kSuccessCode
        if Element.self == YDNotDecode.self {
            return
        }
        else if let dict = self.payload as? [String: Any] {
            self.model = Element.ydDeserialize(from: dict)
        } else if let array = self.payload as? [Any] {
            self.modelArray = [Element].ydDeserialize(from: array) as? [Element]
        }
    }
    
    var description: String {
        return "status: \(status)\npayload: \(payload ?? "")"
    }
    
    required init() {}
}

func H5Url(path: String) -> String {
    if  gH5BaseURL.last != "/" && path.first != "/" {
        return gH5BaseURL + "/" + path
    }
    return gH5BaseURL + path
}

func H5SildeUrl(path: String) -> String {
    if  gH5SildeBaseURL.last != "/" && path.first != "/" {
        return gH5SildeBaseURL + "/" + path
    }
    return gH5SildeBaseURL + path
}

func QualityUrl(path: String) -> String {
    if  gQualityURL.last != "/" && path.first != "/" {
        return gQualityURL + "/" + path
    }
    return gQualityURL + path
}

struct YDNetworkConfig {
    ///app渠道号
    // 企业包是2
    //    static var appChannel = "2"
    // app store 是38
    static var appChannel = "38"
}

class YDNetwork {
    
    static let reachabilityManager = NetworkReachabilityManager()
    
    static var netStatus: YDNetStatus = .unknown
    
    class func request<T>(path: YDAPI, needHud: Bool = false, onSuccess: @escaping (YDNetResponse<T>?) -> Void, onFailure: @escaping (YDNetError) -> Void) {
        let urlPath = path.baseURL.absoluteString + path.path
        if YDNetwork.netStatus == .notReachable {
            let error = YDNetError(status: "FYDLE", message: "没有网络，请检查网络配置～".i18n_common, code: -1)
            onFailure(error)
            YDLogNetError(path: urlPath, code: -1, status: "DisConnect", msg: "没有网络，请检查网络配置～")
            return
        }
        NetWorkRequest(path,callbackQueue: .main, networkDidStYD: {
            DispatchQueue.main.async {
                if needHud { YDHUD.showLoading() }
            }
        }, networkDidEnd: {
            DispatchQueue.main.async {
                if needHud { YDHUD.dimiss() }
            }
        }, errorResult: { (error) -> (Void) in
            DispatchQueue.main.async {
                onFailure(YDNetError.errorWith(error: error as NSError))
                YDLogNetError(path: urlPath, code: error.errorCode, status: "request error", msg: error.errorDescription ?? "")
            }
        }) { (response) -> (Void) in
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                    
                    /*
                    #if DEBUG
                    if let request = response.request,
                       let url = request.url,
                       let method = request.httpMethod {
                        let jsonString = JSONObject.string(withJSONObject: json, options: .prettyPrinted) ?? ""
                        if let body = request.httpBody {
                            let data = String(data: body, encoding: String.Encoding.utf8) ?? ""
                            print("\(method)\n\(url)\nbody \(data)\n\(jsonString)")
                        } else {
                            print("\(method)\n\(url)\n\(jsonString)")
                        }
                    } else {
                        YDLog("进行打印请求原始数据 测试专用 == [----"+"\(json))----]")
                    }
                    #endif
                    */
                    
                    if let dict = json as? [String: Any] {
                        YDHttpLog(path: urlPath, response: dict.jsonString() ?? "", logTag: kNetWorkTag)
                        self.decodeWith(dict: dict, path: urlPath, onSuccess: onSuccess, onFailure: onFailure)
                    } else {
                        onFailure(YDNetError.defaultError())
                        YDLogNetError(path: urlPath, code: -2, status: "decode error", msg: response.description)
                    }
                } catch {
                    onFailure(YDNetError.defaultError())
                    YDLogNetError(path: urlPath, code: -2, status: "decode error", msg: response.description)
                }
            }
            
        }
    }
    
    class func decodeWith<T>(dict: [String: Any], path: String, onSuccess: @escaping (YDNetResponse<T>?) -> Void, onFailure: @escaping (YDNetError) -> Void){
        if let response = YDNetResponse<T>.deserialize(from: dict) {
            response.jsonData = dict
            if response.status == kStatusOK || response.status == "0" {
                response.decode()
                onSuccess(response)
                return
            }
            YDNetError(path: path, code: response.code, status: response.status, msg: response.errors ?? "")
            onFailure(YDNetError(status: response.status, message: response.errors ?? (kDefaultError), code: response.code))
        }
    }
    
}
