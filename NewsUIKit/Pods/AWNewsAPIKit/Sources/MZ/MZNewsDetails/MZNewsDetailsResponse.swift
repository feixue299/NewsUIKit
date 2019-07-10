//
//  MZNewsDetailsResponse.swift
//  NewsAPIKit
//
//  Created by YB on 2019/7/9.
//  Copyright © 2019 YB. All rights reserved.
//

import Foundation

public struct MZNewsDetails: Codable {
    
    public struct Image: Codable {
        public let position: String
        public let imgSrc: String
        public let size: String
    }
    
    public let images: [Image]
    public let title: String
    public let content: String
    public let source: String
    public let ptime: String
    public let docid: String
    public let cover: String
}

public typealias MZNewsDetailsResponse = MZResponse<MZNewsDetails>
