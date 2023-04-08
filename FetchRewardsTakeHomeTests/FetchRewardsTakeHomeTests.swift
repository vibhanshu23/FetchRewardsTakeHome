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
        sut = getDefaultNetworkHandler(url: .mealsUnsorted)
        let networkResponseExpectation = XCTestExpectation(description: "Receieve data from makeURLRequest")
        sut.makeAPICall(with: .mealsUnsorted, completion: {
            (response:[MealObjectFromServer]?, error) in
            XCTAssertNil(error)
            XCTAssertEqual(response?.first?.id, "idMeal") //TODO: change to getmeals() and remove litteral
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
        sut = ViewModel(andNetworkHandler: getDefaultNetworkHandler(url: .mealsUnsorted))

        let networkResponseExpectation = XCTestExpectation(description: "Receieve data from makeURLRequest")
        sut.getMealList { output, error in

            let expectedOutput = self.getMeals()

            XCTAssertEqual(output, expectedOutput )
            networkResponseExpectation.fulfill()
        }

    }
    func test_getMealDetails() throws {
        sut = ViewModel(andNetworkHandler: getDefaultNetworkHandler(url: .details))

        let networkResponseExpectation = XCTestExpectation(description: "Receieve data from makeURLRequest")
        sut.getMealDetails(withMealId: self.getMeals()[1]) { output, error in

            let expectedOutput = self.getDetails()

            XCTAssertEqual(output, expectedOutput )
            networkResponseExpectation.fulfill()
        }
    }

    func test_storeCurrentDetailObject() throws {
        sut = ViewModel(andNetworkHandler: getDefaultNetworkHandler(url: .details))
        sut.storeCurrentDetailObject(response: getServerDetails())
        XCTAssertEqual(sut.currentDetailObject,getDetails())
    }

    
    func test_storeAndSortCurrentMealObject() throws {

        sut = ViewModel(andNetworkHandler: getDefaultNetworkHandler(url: .meals))
        sut.storeAndSortCurrentMealObject(response: getServerMeals())

        let expectedOutput = getMeals(isSorted: true)
        for i in 0..<sut.displayMealList.count{
            let expectedItem = expectedOutput[i]
            let actualOutput = sut.displayMealList[i]
                XCTAssertEqual( actualOutput.id , expectedItem.id )
        }
    }

}

class Modal: XCTestCaseBase {

    var sut: Meal!

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_updateMealWithImage() throws {

        sut = Meal(name: "test", imageURL: "test", id: "test", image: nil)
        let expectedOutput = Utilities.getDefaultImage()

        sut.updateMealWithImage(image: expectedOutput)

        XCTAssertEqual(sut.image,expectedOutput)
        XCTAssertEqual(sut.isImageDownloaded, true)
    }

}
