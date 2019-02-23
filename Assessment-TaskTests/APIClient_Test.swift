//
//  APIClient_Test.swift
//  Assessment-TaskTests
//
//  Created by Noha  on 2/23/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import XCTest
@testable import Assessment_Task

class APIClient_Test: XCTestCase {
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
    }
    
    func test_GET_RequestsTheURL() {
        MoviesAPIClient.sharedClient.session = session
        let url = URL(string: "http://masilotti.com")!
        MoviesAPIClient.sharedClient.getNewMovies(page: 1, success: { (_) in}) { (_) in}
        XCTAssertNotNil(session.lastURL)
//        XCTAssert(session.lastURL! == url)
    }
}

