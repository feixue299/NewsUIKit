//
//  NewsAPIKit.swift
//  NewsAPIKit
//
//  Created by YB on 2019/7/9.
//  Copyright © 2019 YB. All rights reserved.
//

import Moya

public enum NewsAPIKit {
    case mzNewsTypes
    case mzNewsList(typeid: Int, page: Int)
    case mzNewsDetails(newsid: String)
}

extension NewsAPIKit: TargetType {
    public var baseURL: URL {
        switch self {
        case .mzNewsTypes, .mzNewsList, .mzNewsDetails:
            return URL(string: "https://www.mxnzp.com/api")!
        }
    }
    
    public var path: String {
        switch self {
        case .mzNewsTypes:
            return "/news/types"
        case .mzNewsList:
            return "/news/list"
        case .mzNewsDetails:
            return "/news/details"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .mzNewsTypes:
            return .requestPlain
        case .mzNewsList(let typeid, let page):
            return .requestParameters(parameters: ["typeId": typeid, "page": page], encoding: URLEncoding.queryString)
        case .mzNewsDetails(let newsid):
            return .requestParameters(parameters: ["newsId": newsid], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}
