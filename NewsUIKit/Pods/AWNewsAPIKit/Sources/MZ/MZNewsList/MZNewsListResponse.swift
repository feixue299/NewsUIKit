//
//  MZNewsListResponse.swift
//  NewsAPIKit
//
//  Created by YB on 2019/7/9.
//  Copyright © 2019 YB. All rights reserved.
//

import Foundation

public struct MZNews: Codable {
    public let digest: String?
    public let imgList: [String]?
    public let newsId: String
    public let postTime: String?
    public let source: String?
    public let title: String
    public let videoList: [String]?
}

public typealias MZNewsListResponse = MZResponse<[MZNews]>
