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
    
    func testGameDataControllerRequest() {
        
        let expectation = expectationWithDescription("success")
        
        let playerAction = PlayerAction()
        
        let gameDataController:GameDataController = GameDataController()
        gameDataController.postRequestForPlayerAction(playerAction) { (roundResult) -> Void in
            print("")
            print(roundResult)
            print("")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            print("failure")
        }
    }
    
    //  Damage tests
    
    let requestsToMake:Int = 2
    var requestsMade:Int = 0
    
    func testDamage() {
        
        let expectation = expectationWithDescription("success")
        
        makeDamageRequest()
        
        waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            print("failure")
        }
    }
    
    func makeDamageRequest() {
        let gameDataController:GameDataController = GameDataController()
        let playerAction = PlayerAction()
        gameDataController.postRequestForPlayerAction(playerAction) { (roundResult) -> Void in
            if self.requestsMade < self.requestsToMake {
                self.makeDamageRequest()
            }
        }
        requestsMade = requestsMade + 1
    }
    
}
