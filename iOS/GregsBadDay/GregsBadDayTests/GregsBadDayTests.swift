//
//  GregsBadDayTests.swift
//  GregsBadDayTests
//
//  Created by Chris Weathers on 1/30/16.
//
//

import XCTest
@testable import GregsBadDay

class GregsBadDayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRequest() {
        
    }
    
    func testGameDataController() {
        let gameDataController:GameDataController = GameDataController()
        gameDataController.postRequestForTarget("head", value: 16) { () -> Void in
            print("done")
        }
        
        var expectation = expectationWithDescription("heyo")

        waitForExpectationsWithTimeout(50.0) { (error) in
            if error != nil {
                
            }
        }
    }
    
}
