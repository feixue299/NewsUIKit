//
//  NewsListViewController.swift
//  NewsUIKit
//
//  Created by Mr.wu on 2019/7/10.
//  Copyright © 2019 Mr.wu. All rights reserved.
//

import UIKit
import JXSegmentedView
import AWNewsAPIKit
import Kingfisher
import LYEmptyView

open class NewsListViewController: UITableViewController, JXSegmentedListContainerViewListDelegate, NewsListProtocol {
    
    private let typeid: Int
    private var newsList: [MZNews] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var currentPage = 1
    private var isLoading: Bool = false
    
    public required init(typeid: Int) {
        self.typeid = typeid
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.typeid = 0
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tableView.ly_emptyView = LYEmptyView.emptyActionView(with: nil, titleStr: "无数据", detailStr: "当前没有数据，请稍后再试", btnTitleStr: "重新加载", btnClick: { [weak self] in
            self?.refreshData()
        })
        
        refreshData()
    }
    
    @objc private func refreshData() {
        guard !isLoading else { return }
        currentPage = 1
        newsList = []
        requestNewsList()
    }
    
    private func loadMore() {
        guard !isLoading else { return }
        currentPage += 1
        requestNewsList()
    }
    
    private func requestNewsList() {
        guard !isLoading else { return }
        isLoading = true
        let listServer = MZNewsListServer(target: .mzNewsList(typeid: typeid, page: currentPage))
        
        listServer.request({ (result) in
            self.isLoading = false
            self.refreshControl?.endRefreshing()
            switch result {
            case .success(let response):
                self.newsList.append(contentsOf: response.data)
            case .failure(let error):
                print("error:\(error.localizedDescription)")
            }
        }) { (moyaError) in
            self.refreshControl?.endRefreshing()
            self.isLoading = false
            print("moyaError:\(moyaError.localizedDescription)")
        }
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.height + scrollView.contentOffset.y > scrollView.contentSize.height - 300 {
            if currentPage <= 3 {
                loadMore()
            }
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
        let news = newsList[indexPath.row]
        cell.titleLabel.text = news.title
        cell.sourceLabel.text = news.source
        if let imgString = news.imgList?.first {
            cell.imgView.kf.setImage(with: URL(string: imgString))
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let nav = parent?.navigationController {
            let news = newsList[indexPath.row]
            let vc = Injection.newsDetail(news.newsId).viewController
            nav.pushViewController(vc, animated: true)
        }
    }
    
    public func listView() -> UIView {
        return view
    }

}
