//
//  MockNewsService.swift
//  NewsAppTests
//
//  Created by Vania Radmila Alfitri on 31/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

@testable import NewsApp
import Foundation

class MockNewsService: NewsServices {
    
    var isFetchNewsInvoked = false
    static let stubArticles = [Article(source: Source(id: "", name: "CNN"), author: "Jane Dow", title: "Lorem Ipsum", description: "", url: "", urlToImage: "", publishedAt: "", content: ""),
        Article(source: Source(id: "", name: "CNN"), author: "Jane Dow", title: "Lorem Ipsum", description: "", url: "", urlToImage: "", publishedAt: "", content: "")
    ]
    
    func fetchNews(searchText: String, successHandler: @escaping ([Article]) -> Void, errorHandler: @escaping (Error) -> Void) {
        isFetchNewsInvoked = true
        successHandler(MockNewsService.stubArticles)
    }
}
