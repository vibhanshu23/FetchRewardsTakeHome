//
//  MealViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation

class MealViewModel {

    var originalMealList = [Meal]()
    lazy var displayMealList = {
        self.originalMealList.sorted { meal1, meal2 in
            meal1.name < meal2.name
        }
    }()
    var currentDetailObject: MealDetail?
    init(){}

//MARK: Network Interface
    func getMealList(completion: @escaping ([Meal]) -> Void) {
        guard let url = URL(string: MEALSURL)
        else {
            //        TODO: Do error handling
            return
        }
        NetworkHandler.makeAPICall(with: url){
            (response:MealDTO<[MealObjectFromServer]>?, error) in

            if error != nil {
                return
//            TODO: Do error handling
            }
            for item in response!.meals {
                self.originalMealList.append(item.getInterfaceObject())
            }
            completion(self.displayMealList)
        }
    }



    //MARK: Meal Detail

    func getMealDetails(completion: @escaping (MealDetail) -> Void){
        guard let urlDetails = URL(string: MEALDETAILSURL + "53049")
        else {
//                TODO: Do error handling
            return
        }
        NetworkHandler.makeAPICall(
            with: urlDetails
        ){ (response:MealDTO<[MealDetailsObjectFromServer]>?, error) in
            guard error == nil
            else {
//                TODO: Do error handling
                return
            }
            self.currentDetailObject = response!.meals[0].getInterfaceObject()
            completion(self.currentDetailObject!)
        }

    }
}
