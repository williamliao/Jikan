//
//  JikanTests.swift
//  JikanTests
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import XCTest
import WebKit
@testable import Jikan

class JikanTests: XCTestCase {
    
    var sut: URLSession!

    var topContentVM: TopContentViewModel!

    let topViewModel = TopViewModel()

    var fakeData : FakeData!
    
    override func setUpWithError() throws {
        
        sut = URLSession(configuration: .default)
                
        topContentVM = TopContentViewModel(webView: WKWebView(), topViewModel: TopViewModel())
    
        fakeData = FakeData()
        
        //sut.defaults = mockUserDefaults
        
        //        vc = UIStoryboard(name: "Main", bundle: nil)
        //            .instantiateInitialViewController() as? TopContentViewController
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
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
    
    func testValidCallToJikanGetsHTTPStatusCode200() {
            let url =
                URL(string: "https://api.jikan.moe/v3/top/anime/1/upcoming")!
            let promise = expectation(description: "Status code: 200")
            var sc: Int?
            var responseError: Error?
            
            // when
            let dataTask = sut.dataTask(with: url) { data, response, error in
                // then
                if let error = error {
                  responseError = error
                  XCTFail("Error: \(error.localizedDescription)")
                  return
                } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    sc = (response as? HTTPURLResponse)?.statusCode
                  if statusCode == 200 {
                    // 2
                    promise.fulfill()
                  } else {
                    XCTFail("Status code: \(statusCode)")
                  }
                }
              }
              dataTask.resume()
              // 3
              wait(for: [promise], timeout: 5)
            XCTAssertNil(responseError)
            XCTAssertEqual(sc, 200)
    }
    
    func testDecoding() throws {
        
        let url = Bundle.main.url(forResource: "top", withExtension: "json")!
        
        /// When the Data initializer is throwing an error, the test will fail.
        guard let jsonData = try? Data(contentsOf: url) else { return }

        /// The `XCTAssertNoThrow` can be used to get extra context about the throw
        XCTAssertNoThrow(try JSONDecoder().decode(Response.self, from: jsonData))
    }
    
    func testFirstNameNotEmpty() throws {
        topViewModel.respone.value = fakeData.getTopFakeData()

        let firstName =  try XCTUnwrap(topViewModel.respone.value?.top[0].title)
        XCTAssertFalse(firstName.isEmpty)
    }
}
