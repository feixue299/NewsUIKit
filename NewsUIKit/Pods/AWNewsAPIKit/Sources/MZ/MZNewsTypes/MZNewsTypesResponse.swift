//
//  MZNewsTypesResponse.swift
//  NewsAPIKit
//
//  Created by YB on 2019/7/9.
//  Copyright © 2019 YB. All rights reserved.
//

import Foundation

public struct MZNewsType: Codable {
    public let typeId: Int
    public let typeName: String
}

public typealias MZNewsTypesResponse = MZResponse<[MZNewsType]>
