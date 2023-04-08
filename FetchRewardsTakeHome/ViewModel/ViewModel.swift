//
//  ViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation
import UIKit

//MARK: Dependency injection

protocol ViewModelDependency{
    func getMealList(completion: @escaping ([Meal], Error?) -> Void)
    func getMealDetails(withMeal: Meal, completion: @escaping (MealDetail?, Error?) -> Void)
    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void))
}

class ViewModelDependencyClass: ViewModelDependency{ //TODO: check for dependency injection in open source projects
    func getMealList(completion: @escaping ([Meal], Error?) -> Void) {}
    func getMealDetails(withMeal: Meal, completion: @escaping (MealDetail?, Error?) -> Void){}
    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void)) {}
}

//MARK: ViewModel
class ViewModel: ViewModelDependency {

    var originalMealList = [Meal]()
    var displayMealList = [Meal]()
    var currentDetailObject: MealDetail?
    let dependency: ViewModelDependency
    let networkHandler: NetworkHandler

    init(withDependency: ViewModelDependency = ViewModelDependencyClass(), andNetworkHandler: NetworkHandler = NetworkHandler()){
        self.dependency = withDependency
        self.networkHandler = andNetworkHandler
    }


    //MARK: Store network responses
    func storeCurrentDetailObject(response: MealDetailsObjectFromServer){
        self.currentDetailObject = response.getInterfaceObjectAndRemoveNullValues()
    }

    func storeAndSortCurrentMealObject(response: [MealObjectFromServer]){
        for item in response {
            self.originalMealList.append(item.getInterfaceObject())
        }
        self.displayMealList = self.originalMealList.sorted { meal1, meal2 in
            meal1.name < meal2.name
        }
    }

    //MARK: Network Interface
    func getMealList(completion: @escaping ([Meal], Error?) -> Void) {
        guard let url = URL(string: MEALSURL)
        else {
            //FUTURE: Do error handling
            return
        }
        //Future scope: Create a network interface class. This would be only necessary if there are a lot of changes in the model from the server response. I believe it will be better to have a dedicated class for that purpose.
        networkHandler.makeAPICall(with: url){
            (response:MealDTO<[MealObjectFromServer]>?, error) in

            if error != nil {
                DispatchQueue.main.async {
                    completion([Meal](), error)
                }
                return
            }
            DispatchQueue.main.async {
                self.storeAndSortCurrentMealObject(response: response?.meals ?? [])
                completion(self.displayMealList, nil)
            }
        }
    }

    func getMealDetails(withMeal: Meal, completion: @escaping (MealDetail?, Error?) -> Void){
        guard let urlDetails = URL(string: MEALDETAILSURL + withMeal.id)
        else {
            //FUTURE: Do error handling
            return
        }
        networkHandler.makeAPICall(
            with: urlDetails
        ){ (response:MealDTO<[MealDetailsObjectFromServer]>?, error) in
            guard error == nil
            else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {//TODO: Can be moved to Network Class such that response is always on main thread
                self.storeCurrentDetailObject(response: response!.meals[0])
                completion(self.currentDetailObject!, nil)
            }
        }
    }

    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void)) {
        
        networkHandler.makeAPICall(with: url) { (response:Data?, error) in
            if let image = UIImage(data: response!) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            else {
                completion(Utilities.getDefaultImage())
            }
        }

    }
}
