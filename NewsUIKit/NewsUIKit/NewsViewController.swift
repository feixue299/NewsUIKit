//
//  NewsViewController.swift
//  NewsUIKit
//
//  Created by YB on 2019/7/10.
//  Copyright © 2019 YB. All rights reserved.
//

import UIKit
import JXSegmentedView
import SnapKit
import AWNewsAPIKit

public class NewsViewController: UIViewController {
    
    private let segmentView = JXSegmentedView()
    private let segmentDataSource: JXSegmentedTitleDataSource = {
        let data = JXSegmentedTitleDataSource()
        data.titleNormalColor = UIColor.gray
        data.titleSelectedColor = UIColor.black
        data.isTitleColorGradientEnabled = true
        return data
    }()
    private let indicator: JXSegmentedIndicatorLineView = {
        let i = JXSegmentedIndicatorLineView()
        i.indicatorWidth = 20
        return i
    }()
    private var newstypes: [MZNewsType] = [] {
        didSet {
            segmentDataSource.titles = newstypes.map({ $0.typeName })
            segmentDataSource.reloadData(selectedIndex: 0)
            segmentView.reloadData()
            listContainerView.defaultSelectedIndex = 0
            listContainerView.reloadData()
        }
    }
    private lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        segmentView.delegate = self
        segmentView.contentScrollView = listContainerView.scrollView
        segmentView.dataSource = segmentDataSource
        segmentView.indicators = [indicator]
        segmentView.backgroundColor = UIColor.groupTableViewBackground
        
        view.addSubview(segmentView)
        view.addSubview(listContainerView)
        
        segmentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topLayoutGuide.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(40)
        }
        listContainerView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(segmentView)
            maker.top.equalTo(segmentView.snp.bottom)
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        requestSegment()
    }
    
    private func requestSegment() {
        let typesServer = MZNewsTypesServer(target: .mzNewsTypes)
        typesServer.request({ (result) in
            switch result {
            case .success(let response):
                self.newstypes = response.data
            case .failure(let error):
                print("error:\(error.localizedDescription)")
            }
        }, failure: { (moyaError) in
            print("moyaError:\(moyaError.localizedDescription)")
        })
    }
}

extension NewsViewController: JXSegmentedViewDelegate {
    public func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
    
    public func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        listContainerView.didClickSelectedItem(at: index)
    }
    
    public func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}

extension NewsViewController: JXSegmentedListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentDataSource.titles.count
    }
    
    public func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return NewsListViewController(typeid: newstypes[index].typeId)
    }
}
