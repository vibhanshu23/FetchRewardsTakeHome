//
//  FetchRewardsTakeHomeTests.swift
//  FetchRewardsTakeHomeTests
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import XCTest
@testable import FetchRewardsTakeHome

final class FetchRewardsTakeHomeTests: XCTestCaseBase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class NetworkHandlerTests: XCTestCaseBase {

    var sut: NetworkHandler!

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_makeRequest() throws {
        sut = getDefaultNetworkHandler(url: .meals)
        let networkResponseExpectation = XCTestExpectation(description: "Receieve data from makeURLRequest")
        sut.makeAPICall(with: .meals, completion: {
            (response:[MealObjectFromServer]?, error) in
            XCTAssertNil(error)
            XCTAssertEqual(response?.first?.id, "idMeal")
            networkResponseExpectation.fulfill()
        })
        //FIXME: below test fails sometimes because of timout!
        wait(for: [networkResponseExpectation], timeout: 2.1)
    }
}

class ViewModelTests: XCTestCaseBase {

    var sut: ViewModel!

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_getMealList() throws {
        sut = ViewModel(andNetworkHandler: getDefaultNetworkHandler(url: .meals))

        let networkResponseExpectation = XCTestExpectation(description: "Receieve data from makeURLRequest")
        sut.getMealList { mealList, error in

            let result = self.getMeals()

            XCTAssertEqual(mealList, result )
            networkResponseExpectation.fulfill()
        }

    }
    func test_getMealDetails() throws {
        sut = ViewModel(andNetworkHandler: getDefaultNetworkHandler(url: .details))

        let networkResponseExpectation = XCTestExpectation(description: "Receieve data from makeURLRequest")
        sut.getMealDetails(withMeal: self.getMeals()[1]) { mealDetail, error in

            let result = self.getDetails()

            XCTAssertEqual(mealDetail, result )
            networkResponseExpectation.fulfill()
        }
    }

}
