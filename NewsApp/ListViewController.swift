//
//  ListViewController.swift
//  NewsApp
//
//  Created by Vania Radmila Alfitri on 29/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var networkLayer = NetworkLayer.shared
    private let newsService: NewsServices
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    
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
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "List")

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListTableViewCell
        let article = articles[indexPath.row]
        cell.setupView(article: article)
        return cell 
    }
    
    
}
