//
//  APIEndpoints.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/8/23.
//

import Foundation

enum test_APIEndpoints: String{ //used for unit testing
    case mealsUnsorted = "mealsUnsorted"
    case meals = "meals"
    case details = "details"
}

enum APIEndpoints {

    private static let baseURL = URL(string: "https://themealdb.com/api/json/v1/1/")!

    case getMeals
    case getMealDetails(String)

    var url: URL {
        switch self {
            case .getMeals:
                return APIEndpoints.baseURL.appending(path: "filter.php?c=Dessert")

            case .getMealDetails(let mealId):
                return APIEndpoints.baseURL.appending(path: "lookup.php?i=\(mealId)")
        }
    }

}
