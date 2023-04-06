//
//  XCTestCaseBase.swift
//  FetchRewardsTakeHomeTests
//
//  Created by Vibhanshu Jain on 4/6/23.
//

import XCTest
@testable import FetchRewardsTakeHome

class XCTestCaseBase : XCTestCase{

    let meals =
        """
        [
        {
        "strMeal": "Apam balik",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
        "idMeal": "idMeal"
        },
        {
        "strMeal": "Apple & Blackberry Crumble",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
        "idMeal": "52893"
        },
        {
        "strMeal": "Apple Frangipan Tart",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
        "idMeal": "52768"
        }
        ]
        """
        .data(using: .utf8) ?? Data()

    func getMeals() -> [AnyObject]{
        (try! JSONSerialization.jsonObject(with: meals, options: [])) as! [AnyObject]

    }
    func getDetails() -> [AnyObject]{
        (try! JSONSerialization.jsonObject(with: details, options: [])) as! [AnyObject]
    }


    let details =
        """
        {
        "idMeal": "idMeal",
        "strMeal": "Apam balik",
        "strInstructions": "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.",
        "strIngredient1": "Milk",
        "strIngredient2": "Oil",
        "strIngredient3": "Eggs",
        "strIngredient4": "Flour",
        "strIngredient5": "Baking Powder",
        "strIngredient6": "Salt",
        "strIngredient7": "Unsalted Butter",
        "strIngredient8": "Sugar",
        "strIngredient9": "Peanut Butter",
        "strIngredient10": "Peanut",
        "strIngredient11": "",
        "strIngredient12": "",
        "strIngredient13": "",
        "strIngredient14": "",
        "strIngredient15": "",
        "strIngredient16": "",
        "strIngredient17": "",
        "strIngredient18": "",
        "strIngredient19": "",
        "strIngredient20": "",
        "strMeasure1": "200ml",
        "strMeasure2": "60ml",
        "strMeasure3": "2",
        "strMeasure4": "1600g",
        "strMeasure5": "3 tsp",
        "strMeasure6": "1/2 tsp",
        "strMeasure7": "25g",
        "strMeasure8": "45g",
        "strMeasure9": "3 tbs",
        "strMeasure10": " Peanut",
        "strMeasure11": " ",
        "strMeasure12": " ",
        "strMeasure13": " ",
        "strMeasure14": " ",
        "strMeasure15": " ",
        "strMeasure16": " ",
        "strMeasure17": " ",
        "strMeasure18": " ",
        "strMeasure19": " ",
        "strMeasure20": " ",
        "strSource": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        "strImageSource": null,
        "strCreativeCommonsConfirmed": null,
        "dateModified": null
        }
        """.data(using: .utf8) ?? Data()

    let dummyURL = URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")

    func getDefaultNetworkHandler(url: String) -> NetworkHandler{
        URLProtocolMock.testData =  [URL(string:url)!: meals]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: config)
        return NetworkHandler(session: urlSession)
    }

}


class URLProtocolMock: URLProtocol {
    static var testData = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {

        if let url = request.url {

            if let data = URLProtocolMock.testData[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() { }
}
