//
//  YDMultiMoyaProvider.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation
import Moya

open class YDMultiMoyaProvider: MoyaProvider<MultiTarget> {
    
}


extension YDMultiMoyaProvider {
    func requestDecoded<T: YDNetworkTargetType>(_ target: T,
                                                 callbackQueue: DispatchQueue? = .none,
                                                 progress: ProgressBlock? = .none,
                                                 completion: @escaping Moya.Completion) -> Cancellable {
        return request(MultiTarget(target), callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
}
