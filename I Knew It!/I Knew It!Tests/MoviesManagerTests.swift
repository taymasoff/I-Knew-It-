//
//  MoviesManagerTests.swift
//  I Knew It!Tests
//
//  Created by Тимур Таймасов on 15.06.2021.
//

import XCTest
@testable import I_Knew_It_

class MoviesManagerTests: XCTestCase {

    var moviesManager = MoviesManager()
    var requestAssembler = RequestAssembler()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
