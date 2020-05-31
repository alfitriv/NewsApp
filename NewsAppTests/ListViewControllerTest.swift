//
//  ListViewControllerTest.swift
//  NewsAppTests
//
//  Created by Vania Radmila Alfitri on 31/05/20.
//  Copyright © 2020 Vania Radmila Alfitri. All rights reserved.
//

import XCTest
import UIKit
@testable import NewsApp

class ListViewControllerTest: XCTestCase {
    var sut: ListViewController!
    var mockService: MockNewsService!

    override func setUp() {
        super.setUp()
        mockService = MockNewsService()
        sut = ListViewController(newsService: mockService)
    }
    
    func testFetchNewsIsInvokedInViewDidLoad() {
        _ = sut.view
        XCTAssertTrue(mockService.isFetchNewsInvoked)
    }

}
