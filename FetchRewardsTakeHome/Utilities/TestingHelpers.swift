//
//  TestingHelpers.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/8/23.
//

import Foundation

class TestingHelpers{
    let meals = [
        [        "strMeal": "Apam balik",
                 "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                 "idMeal": "idMeal"
        ],
        [
            "strMeal": "Apple & Blackberry Crumble",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            "idMeal": ""
        ],
        [
            "strMeal": "ZApple Frangipan Tart",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "idMeal": "52768"
        ]
    ]

    let mealsUnsorted = [
        [        "strMeal": "Apple & Blackberry Crumble",
                 "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                 "idMeal": "idMeal"
        ],
        [
            "strMeal": "ZApple Frangipan Tart",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            "idMeal": ""
        ],
        [
            "strMeal": "Apam balik",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "idMeal": "52768"
        ]
    ]

    let details =
    [
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
        "strImageSource": nil,
        "strCreativeCommonsConfirmed": nil,
        "dateModified": nil
    ]

    let dummyURL = URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")

    func getDetails() -> MealDetail{
        let decoder = JSONDecoder()
        let data = try! JSONSerialization.data(withJSONObject: details, options: [])
        let meal = try! decoder.decode(MealDetailsObjectFromServer.self, from: data)
        return meal.getInterfaceObjectAndRemoveNullValues()

    }

    func getMeals(isSorted: Bool = false) -> [Meal]{
        var arr = [Meal]()
        let jsonObject = isSorted ? meals : mealsUnsorted
        do {
            let decoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let meal = try decoder.decode([MealObjectFromServer].self, from: data)
            for object in meal {
                arr.append(object.getInterfaceObject())
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
        return arr

    }
    
    func getServerDetails() -> MealDetailsObjectFromServer{
        let decoder = JSONDecoder()
        let data = try! JSONSerialization.data(withJSONObject: details, options: [])
        return try! decoder.decode(MealDetailsObjectFromServer.self, from: data)

    }

    func getServerMeals() -> [MealObjectFromServer]{
        do {
            let decoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: meals, options: [])
            return try decoder.decode([MealObjectFromServer].self, from: data)

        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
        return [MealObjectFromServer]()

    }


    func getDefaultNetworkHandler(url: test_APIEndpoints) -> NetworkHandler{
        switch url{
            case .meals:
                URLProtocolMock.testData =  [
                    URL(string: url.rawValue)!
                    : try! JSONSerialization.data(withJSONObject: meals,options: [])
                ]

            case .details:
                let obj = [
                    URL(string:url.rawValue)! : try! JSONSerialization.data(withJSONObject: details ,options: [])
                ]
                URLProtocolMock.testData =  obj

            case .mealsUnsorted:
                let obj = [
                    URL(string:url.rawValue)! : try! JSONSerialization.data(withJSONObject: mealsUnsorted ,options: [])
                ]
                URLProtocolMock.testData =  obj
        }
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

