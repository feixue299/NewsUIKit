//
//  Server.swift
//  NewsAPIKit
//
//  Created by YB on 2019/7/9.
//  Copyright © 2019 YB. All rights reserved.
//

import Foundation
import Moya

public struct Server<Response: Codable> {
    public var newsAPIServer = NewsAPIServer()
    public var target: NewsAPIKit
    
    public init(target: NewsAPIKit) {
        self.target = target
    }
    
    public typealias RequestResult = Result<Response, Error>
    
    public func request(_ success: ((RequestResult) -> Void)?, failure: ((MoyaError) -> Void)? = nil) {
        newsAPIServer.request(target) { (result) in
            switch result {
            case .success(let value):
                if let json = try? value.mapJSON() {
                    print("json:\(json)")
                } else if let string = try? value.mapString() {
                    print("string:\(string)")
                } else if let image = try? value.mapImage() {
                    print("image:\(image)")
                }
                success?(RequestResult.init(catching: { () -> Response in
                    return try JSONDecoder().decode(Response.self, from: value.data)
                }))
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
}
