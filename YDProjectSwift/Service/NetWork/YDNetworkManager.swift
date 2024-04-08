//
//  YDNetworkManager.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation
import Moya
import Alamofire

/// 超时时长
private var requestTimeOut:Double = 10

public typealias ArtResponse = Response
public typealias ArtError = MoyaError
///请求开始的回调
public typealias networkActivityDidStart = (()->Void)
///请求的进度的回调
public typealias networkPrograss = (()->Void)
/// 请求结束的回调
public typealias networkActivityDidEnd = (()->Void)
///成功数据的回调
public typealias successCallback = ((ArtResponse) -> (Void))
///失败的回调
//public typealias failedCallback = ((ArtResponse) -> (Void))
///网络错误的回调
public typealias errorCallback = ((ArtError) -> (Void))


///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    ///这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    return endpoint
}

///网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            LogInfo("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            LogInfo("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
let policies: [String: ServerTrustPolicy] = [
    "example.com": .pinPublicKeys(
        publicKeys: ServerTrustPolicy.publicKeysInBundle(),
        validateCertificateChain: true,
        validateHost: true
    )
]
*/

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
//}


///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
@discardableResult //当我们需要主动取消网络请求的时候可以用返回值Cancellable, 一般不用的话做忽略处理
public func NetWorkRequest<T: YDNetworkTargetType>(_ target: T,
                                                    callbackQueue: DispatchQueue? = .none,
                                                    progress: ProgressBlock? = .none,
                                                    networkDidStart: networkActivityDidStart? = .none,
                                                    networkDidEnd: networkActivityDidEnd? = .none,
                                                    errorResult:errorCallback? = .none,
                                                    completion: @escaping successCallback) -> Cancellable? {
    
    // 调整超时时间
    requestTimeOut = target.requestTimeOut
    
    // 先判断网络是否有链接 没有的话直接返回--代码略
//    if !isNetworkConnect{
//        print("提示用户网络似乎出现了问题")
//        return nil
//    }
    
    // 请求状态
    let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
        //targetType 是当前请求的基本信息
        switch(changeType){
        case .began:
            networkDidStart?()
            
        case .ended:
            networkDidEnd?()
        }
    }
    
    // 请求
    let Provider = YDMultiMoyaProvider(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
    return Provider.requestDecoded(target, callbackQueue: callbackQueue, progress: progress) { (result) in
        switch result {
        case let .success(response):
            completion(response)
        case let .failure(error):
            errorResult?(error)
        }
    }
}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}

