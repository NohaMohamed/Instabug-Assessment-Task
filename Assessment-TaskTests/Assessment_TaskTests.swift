//
//  Assessment_TaskTests.swift
//  Assessment-TaskTests
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import XCTest
@testable import Assessment_Task

class Assessment_TaskTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testCellForRowAt()  {
        let vc = ViewController()
        vc.viewDidLoad()
        XCTAssertNotNil(vc.view)
    }
    /*func testGetMoviesSuccessReturnsMovies() {
        let jsonData = "[{\"title\": \"Mission Impossible Fallout\",\"detail\": \"A Tom Cruise Movie\"}]".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        let apiRespository = MoviesAPIClient.sharedClient
        apiRespository.session = mockURLSession
        let moviesExpectation = expectation(description: "movies")
        var moviesResponse: [Movie]?
        
        apiRespository.getNewMovies(page: 1, success: { (movies) in
            moviesResponse = movies as? [Movie]
            moviesExpectation.fulfill()
        }) { (error) in
            
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(moviesResponse)
        }
    }*/

}
