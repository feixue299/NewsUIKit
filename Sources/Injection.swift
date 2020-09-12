//
//  Injection.swift
//  NewsUIKit
//
//  Created by Mr.wu on 2020/9/12.
//  Copyright © 2020 Mr.wu. All rights reserved.
//

import Foundation
import JXSegmentedView

public protocol NewsDetailProtocol {
    init(newsid: String)
    var viewController: UIViewController { get }
}

public protocol NewsListProtocol {
    init(typeid: Int)
    var viewController: UIViewController & JXSegmentedListContainerViewListDelegate { get }
}

public extension NewsDetailProtocol where Self: UIViewController {
    var viewController: UIViewController {
        return self
    }
}

public extension NewsListProtocol where Self: UIViewController & JXSegmentedListContainerViewListDelegate {
    var viewController: UIViewController & JXSegmentedListContainerViewListDelegate {
        return self
    }
}

public struct Injection {
    static var newsDetail: ((_ newsid: String) -> NewsDetailProtocol) = { (newsid) in
        return NewsDetailViewController(newsid: newsid)
    }
    static var newsList: ((_ typeid: Int) -> NewsListProtocol) = { (typeid) in
        return NewsListViewController(typeid: typeid)
    }
    
    private init() { }
}

