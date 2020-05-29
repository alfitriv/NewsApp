//
//  Article.swift
//  NewsApp
//
//  Created by Vania Radmila Alfitri on 29/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

import Foundation

struct Article: Codable {
    var source: Source
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String
    var content: String?
}
