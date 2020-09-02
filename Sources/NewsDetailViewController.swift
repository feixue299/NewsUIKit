//
//  NewsDetailViewController.swift
//  NewsUIKit
//
//  Created by YB on 2019/7/10.
//  Copyright © 2019 YB. All rights reserved.
//

import UIKit
import AWNewsAPIKit
import LYEmptyView

open class NewsDetailViewController: UIViewController {
    
    private let newsid: String
    private let scrollView = UIScrollView()
    
    public required init(newsid: String) {
        self.newsid = newsid
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.newsid = ""
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "详情"
        view.ly_emptyView = LYEmptyView.emptyActionView(with: nil, titleStr: "无数据", detailStr: "当前没有数据，请稍后再试", btnTitleStr: "重新加载", btnClick: { [weak self] in
            self?.requestDetail()
        })
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        requestDetail()
    }
    
    fileprivate func createViews(_ response: (MZNewsDetailsResponse)) {
        let content = ParseContent(content: response.data.content)
        var previousView: UIView?
        var newView: UIView
        var types = content.contentTypeGroup
        types.insert(ParseContentType.b(content: response.data.title), at: 0)
        for (index, contentType) in types.enumerated() {
            switch contentType {
            case .b(let content):
                let label = UILabel()
                newView = label
                label.numberOfLines = 0
                label.text = content
                label.font = UIFont.boldSystemFont(ofSize: 30)
                label.textAlignment = .center
                
            case .p(let content):
                let label = UILabel()
                newView = label
                label.numberOfLines = 0
                label.text = content
                
            case .img(let id):
                let imageView = UIImageView()
                newView = imageView
                imageView.contentMode = .scaleAspectFit
                if let image = response.data.images.first(where: { $0.position == id }),
                    let url = URL(string: image.imgSrc) {
                    let size = image.size.split(separator: "*")
                    if let widthStr = size.first, let heightStr = size.last,
                        let width = Int(widthStr), let height = Int(heightStr) {
                        imageView.snp.makeConstraints({ (maker) in
                            maker.height.equalTo(imageView.snp.width).multipliedBy(CGFloat(height) / CGFloat(width))
                        })
                    }
                    imageView.kf.setImage(with: url)
                }
            }
            self.scrollView.addSubview(newView)
            newView.snp.makeConstraints({ (maker) in
                maker.left.right.equalToSuperview().inset(5)
            })
            if let pView = previousView {
                if index == types.count - 1 {
                    newView.snp.makeConstraints({ (maker) in
                        maker.top.equalTo(pView.snp.bottom).offset(5)
                        maker.bottom.equalToSuperview().inset(5)
                    })
                } else {
                    newView.snp.makeConstraints({ (maker) in
                        maker.top.equalTo(pView.snp.bottom).offset(5)
                    })
                }
            } else {
                newView.snp.makeConstraints({ (maker) in
                    maker.top.equalToSuperview().offset(20)
                    maker.width.equalToSuperview().offset(-10)
                })
            }
            previousView = newView
        }
    }
    
    func requestDetail() {
        let detailServer = MZNewsDetailsServer(target: .mzNewsDetails(newsid: newsid))
        detailServer.request({ (result) in
            switch result {
            case .success(let response):
                self.createViews(response)
                self.view.ly_hideEmpty()
            case .failure(let error):
                print("error:\(error.localizedDescription)")
                self.view.ly_showEmpty()
            }
        }) { (moyaError) in
            print("moyaError:\(moyaError.localizedDescription)")
            self.view.ly_showEmpty()
        }
    }
}

private struct ParseContent {
    
    private(set) var contentTypeGroup: [ParseContentType] = []
    
    private var labelContentGroup: [String] = []
    
    init(content: String) {
        
        let regex = "<\\w*>[^<]*</\\w*]*>|<!--IMG#[\\d]*-->"
        
        let regular = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
        let results = regular.matches(in: content, options: .reportProgress, range: NSRange(location: 0, length: content.count))
        
        labelContentGroup = results.map({ (content as NSString).substring(with: $0.range) })
        contentTypeGroup = labelContentGroup.map({ (label) in
            if label.hasPrefix("<p>") && label.hasSuffix("</p>") {
                return .p(content: label.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: ""))
            } else if label.hasPrefix("<b>") && label.hasSuffix("</b>") {
                return .b(content: label.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: ""))
            } else {
                return .img(id: label)
            }
        })
    }
    
}

private enum ParseContentType {
    case p(content: String)
    case img(id: String)
    case b(content: String)
}
