//
//  MealViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation

class MealViewModel {

    init(){}

//MARK: Network Interface
    func getMealList(completion: @escaping ([Meal]) -> Void) {
        guard let url = URL(string: MEALSURL)
        else {
            //        TODO: Do error handling
            return
        }
        NetworkHandler.makeAPICall(with: url){
            (response:MealDTO<[Meal]>?, error) in
            if error != nil {
                return
//            TODO: Do error handling
            }
            print(response)

        }
    }



    func getMealDetails(completion: ([MealDetailLocal]) -> Void){
        guard let urlDetails = URL(string: MEALDETAILSURL + "53049")
        else {
//                TODO: Do error handling
            return
        }
        NetworkHandler.makeAPICall(
            with: urlDetails
        ){ (response:MealDTO<[MealDetails]>?, error) in
            guard error != nil
            else {
//                TODO: Do error handling
                return
            }

            print(response)
        }

    }
}
