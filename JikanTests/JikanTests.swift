//
//  JikanTests.swift
//  JikanTests
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import XCTest
@testable import Jikan

class JikanTests: XCTestCase {
    
    let topViewModel = TopViewModel()

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

extension JikanTests {
    func testListcount() {
        let exception = XCTestExpectation()
        
        topViewModel.service.getFeed(fromRoute: Routes.upcoming, parameters: nil) { [weak self] (result) in
            
            switch result {
                case .success(let feedResult):
                    self?.topViewModel.respone.value = feedResult
                    exception.fulfill()
                case .failure( _):
                    break
                    
            }
        }
        
        let wait = XCTWaiter()
        _ = wait.wait(for: [exception], timeout: 10)
            
        XCTAssert(topViewModel.respone.value?.top.count == 50, "API Parse Error")
    }
    
    func testFavoriterCount(){
        
        let exception = XCTestExpectation()
        
        topViewModel.service.getFeed(fromRoute: Routes.upcoming, parameters: nil) { [weak self] (result) in
            
            switch result {
                case .success(let feedResult):
                    self?.topViewModel.respone.value = feedResult
                    exception.fulfill()
                case .failure( _):
                    break
                    
            }
        }
        
        let wait = XCTWaiter()
        _ = wait.wait(for: [exception], timeout: 10)
        
        guard let top = topViewModel.respone.value?.top[0], let top2 = topViewModel.respone.value?.top[1], let top3 = topViewModel.respone.value?.top[2] else { return  }
        
        topViewModel.favorites.value.insert(top)
        topViewModel.favorites.value.insert(top2)
        topViewModel.favorites.value.insert(top3)
        
        XCTAssert(topViewModel.favorites.value.count == 3, "Favorite count error")
    }
}
