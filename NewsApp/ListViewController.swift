//
//  ListViewController.swift
//  NewsApp
//
//  Created by Vania Radmila Alfitri on 29/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

import UIKit

enum CellType {
    case header
    case list
}

class ListViewController: UIViewController {
    var networkLayer = NetworkLayer.shared
    private let newsService: NewsServices
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    var bitcoinArticles: [Article] = []
    var sections: [CellType] = [CellType.header, CellType.list]
    
    init(newsService: NewsServices) {
        self.newsService = newsService
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkLayer.fetchNews(successHandler: { (articles) in
            self.articles = articles
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
        
        networkLayer.fetchBitCoinNews(successHandler: { (articles) in
            self.bitcoinArticles = articles
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "List")
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")

    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .header:
            return 1
        case .list:
            return bitcoinArticles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderTableViewCell
            if let article = articles.first {
              cell.setupView(article: article)
            }
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListTableViewCell
            let article = bitcoinArticles[indexPath.row]
            cell.setupView(article: article)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        switch section {
        case .header:
            return "Trending"
        case .list:
            return "Featured"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        
        switch section {
        case .header:
            return 300
        case .list:
            return 100
        }
    }
}
