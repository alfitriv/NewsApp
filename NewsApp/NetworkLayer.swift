//
//  NetworkLayer.swift
//  NewsApp
//
//  Created by Vania Radmila Alfitri on 29/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

import Foundation

protocol NewsServices {
    func fetchNews(searchText: String,  successHandler: @escaping ([Article]) -> Void, errorHandler: @escaping (Error) -> Void)
}

class NetworkLayer: NewsServices {
    static var shared = NetworkLayer()
    private init() {}
    
    func fetchNews(searchText: String, successHandler: @escaping ([Article]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let session = URLSession.shared
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/everything?q=\(searchText)&apiKey=44512f7a934e4715b1666758e372c318")!)
        
        session.dataTask(with: urlRequest) { (data,response,error) in
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorHandler(NSError(domain: "", code: 0, userInfo: nil))
                }
                return
            }
            
            print(data)
            
            do {
                let newsList = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    successHandler(newsList.articles)
                }
                
            } catch {
                
            }
            
        }.resume()
        
    }
        
}
