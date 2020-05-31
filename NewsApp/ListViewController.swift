//
//  ListViewController.swift
//  NewsApp
//
//  Created by Vania Radmila Alfitri on 29/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

import UIKit
import WebKit

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
    var webView: WKWebView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredArticles: [Article] = []
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    init(newsService: NewsServices) {
        self.newsService = newsService
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        networkLayer.fetchNews(successHandler: { (articles) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.articles = articles
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
  
        searchController.searchBar.delegate = self
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.placeholder = "Search Topic"
           navigationItem.searchController = searchController
           definesPresentationContext = true
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "List")
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.separatorStyle = .none

    }
    
    func searchContentForSearchText(_ searchText: String) {
        networkLayer.fetchNews(searchText: searchText, successHandler: { (articles) in
            self.articles = articles
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            self.tableView.reloadData()
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()

        }
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
            return articles.count - 1
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
            let article = articles[indexPath.row + 1]
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
            return 350
        case .list:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        //let bitcoinArticle = bitcoinArticles[indexPath.row]
        let section = sections[indexPath.section]
        let detailVC = DetailViewController.init(nibName: "DetailViewController", bundle: nil)
        self.navigationController?.pushViewController(detailVC, animated: true)

        switch section {
        case .header:
            detailVC.chosenUrl = article.url ?? ""
        case .list:
            detailVC.chosenUrl = article.url ?? ""

        }
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        searchContentForSearchText(searchBar.text ?? "")
        tableView.reloadData()
    }
}
