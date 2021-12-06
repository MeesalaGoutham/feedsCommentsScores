//
//  feeds_demoTests.swift
//  feeds-demoTests
//
//  Created by Goutham Meesala on 05/12/21.
//

import XCTest
@testable import feeds_demo

class feeds_demoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFeedsAPI() {
        let viewModel = FeedsViewModel()
        var feedsResponse: [Feed]?
        
        let expectation = expectation(description: "Feeds")
        viewModel.fetchFeeds() { (feeds, error) in
            feedsResponse = feeds
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(feedsResponse)
        }
    }
    
    func testBextSetFeedsAPI() {
        let viewModel = FeedsViewModel()
        var feedsResponse: [Feed]?
        
        let expectation = expectation(description: "Feeds")
        viewModel.fetchFeeds(nextSet: Config.feedsURL_nextSet) { (feeds, error) in
            feedsResponse = feeds
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(feedsResponse)
        }
    }

}
