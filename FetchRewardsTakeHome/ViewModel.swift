//
//  ViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation

//MARK: Dependency injection

protocol ViewModelDependency{

    func getMealList(completion: @escaping ([Meal], Error?) -> Void)
    func getMealDetails(completion: @escaping (MealDetail?, Error?) -> Void)
}

class ViewModelDependencyClass: ViewModelDependency{
    func getMealList(completion: @escaping ([Meal], Error?) -> Void) {}
    func getMealDetails(completion: @escaping (MealDetail?, Error?) -> Void) {}
}

//MARK: Model
class ViewModel: ViewModelDependency {

    var originalMealList = [Meal]()
    var displayMealList = [Meal]()
    var currentDetailObject: MealDetail?
    let dependency: ViewModelDependency

    init(withDependency: ViewModelDependency){
        self.dependency = withDependency
    }

    //MARK: Network Interface
    func getMealList(completion: @escaping ([Meal], Error?) -> Void) {
        guard let url = URL(string: MEALSURL)
        else {
            //        TODO: Do error handling
            return
        }
        NetworkHandler.makeAPICall(with: url){
            (response:MealDTO<[MealObjectFromServer]>?, error) in

            if error != nil {
                DispatchQueue.main.async {
                    completion([Meal](), error)
                }
                return
            }
            for item in response!.meals {
                self.originalMealList.append(item.getInterfaceObject())
            }
            self.displayMealList = self.originalMealList.sorted { meal1, meal2 in
                meal1.name < meal2.name
            }

            DispatchQueue.main.async {
                completion(self.displayMealList, nil)
            }
        }
    }

    func getMealDetails(completion: @escaping (MealDetail?, Error?) -> Void){
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
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            self.currentDetailObject = response!.meals[0].getInterfaceObject()
            DispatchQueue.main.async {
                completion(self.currentDetailObject!, nil)
            }
        }

    }
}
