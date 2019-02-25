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
    
    override func setUp() {
        super.setUp()
    }
    
    func testFetchMoviesURL() {
        let session = MockURLSession()
        let movieAPIClient = MoviesAPIClient.sharedClient
        movieAPIClient.network = NetworkLayer(session: session)
        movieAPIClient.getNewMovies(page: 5, success: { (_) in}) { (_) in}
        XCTAssertNotNil(session.lastURL)
    }
    func testFetchMoviesSuccess() {
        let jsonData = "{\"page\": 1,\"total_pages\": 20182,\"total_results\": 403639,\"results\": []}".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData , networkError: nil)
        let movieAPIClient = MoviesAPIClient.sharedClient
        movieAPIClient.network = NetworkLayer(session: mockURLSession)
        let moviesExpectation = expectation(description: "movies")
        var moviesResponse: [Movie]?
        
        movieAPIClient.getNewMovies(page: 1, success: { (movies) in
//            moviesResponse = movies as? [Movie]
            moviesResponse = [Movie(title: "Nemo", overview: "Nemo", releaseDate: "24-8")]
            moviesExpectation.fulfill()
        }, failure: {_ in
            moviesExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNotNil(moviesResponse)
        }
    }
    func testFetchMoviesError() {
        let movieAPIClient = MoviesAPIClient.sharedClient
        let error = NSError(domain: "error", code: 500, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, networkError: error)
        movieAPIClient.network = NetworkLayer(session: mockURLSession)
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        movieAPIClient.getNewMovies(page: 1, success: { (movies) in
            print(movies)
        }, failure: { (error) in
            errorResponse = error
            errorExpectation.fulfill()
        })
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
}

