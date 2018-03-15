//
//  XHHomeChannelController.swift
//  Headline
//
//  Created by Li on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeChannelController: UIViewController,XHPageController {
    
    var category: XHHomeChannel.XHChannelCategory! {
        didSet {
            //根据类别进行布局
        }
    }
    
    var isInReuse: Bool = true
    
    private let tableView = XHAutoHeightCellTableView(frame: .zero, style: .grouped)
    
    private var response: XHNewsResponse?
    
    private var models: [XHHomeNews] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        queryNews(refreshType: .auto)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.mj_header = XHRefreshGifHeader()
        tableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_footer = XHRefreshGifFooter()
        tableView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.register(XHHomeNewsCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func queryNews(refreshType: XHRefreshType,completion: (() -> Void)? = nil) {
        
        category.queryNews(refreshType: refreshType) { [weak self](response) in
            if let response = response {
                self?.response = response
                let models = response.models;
                switch refreshType {
                case .auto:
                    self?.models.removeAll()
                    self?.models.append(contentsOf: models)
                    self?.tableView.reloadData()
                case .header:
                    self?.models.insert(contentsOf: models, at: 0)
                    var insertIndexPaths = [IndexPath]()
                    for index in 0 ..< models.count {
                        insertIndexPaths.append(IndexPath(row: index, section: 0))
                    }
                    if #available(iOS 11.0, *) {
                        self?.tableView.performBatchUpdates({
                            self?.tableView.insertRows(at: insertIndexPaths, with: .automatic)
                        })
                    } else {
                        self?.tableView.beginUpdates()
                        self?.tableView.insertRows(at: insertIndexPaths, with: .automatic)
                        self?.tableView.endUpdates()
                    }
                    
                case .footer:
                    self?.models.append(contentsOf: models)
                }
            }
            completion?()
        }
    }
    
    @objc private func headerRefresh() {
        queryNews(refreshType: .header) {[weak self] in
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
    @objc private func footerRefresh() {
        queryNews(refreshType: .footer) {[weak self] in
            if let has_more = self?.response?.has_more,!has_more {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.mj_footer.endRefreshing()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHHomeChannelController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XHHomeNewsCell
        cell.setNews(models[indexPath.row])
        return cell
    }
    
}

extension XHHomeChannelController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView as! XHAutoHeightCellTableView).cellHeight(for: indexPath, execute: { (cell: XHHomeNewsCell) in
            cell.setNews(models[indexPath.row])
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.contentInset)
    }
}
