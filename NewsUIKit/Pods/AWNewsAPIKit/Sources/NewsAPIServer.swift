//
//  NewsAPIServer.swift
//  NewsAPIKit
//
//  Created by YB on 2019/7/9.
//  Copyright © 2019 YB. All rights reserved.
//

import Foundation
import Moya

public struct NewsAPIServer {
    
    public init() { }
    
    public var provider = MoyaProvider<NewsAPIKit>()
    
    @discardableResult
    public func request(_ target: NewsAPIKit,
                        callbackQueue: DispatchQueue? = .none,
                        progress: ProgressBlock? = .none,
                        completion: @escaping Completion) -> Cancellable {
        return provider.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    
}
