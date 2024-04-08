//
//  YDNetworkTargetType.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation
import Moya
import Alamofire


public typealias YDMethod = Moya.Method
public typealias YDTask = Moya.Task
public typealias YDURLEncoding = Alamofire.URLEncoding
public typealias YDValidationType = Moya.ValidationType

public protocol YDNetworkTargetType: TargetType {
    var requestTimeOut: Double { get }
}
