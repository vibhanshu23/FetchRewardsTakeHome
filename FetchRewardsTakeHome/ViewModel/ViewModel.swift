//
//  ViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//
//  This file contains:
//  The buisiness logic to convert the network object to the inferface object
//  It will/or have the updated model for the UI

import Foundation
import UIKit

//MARK: Dependency injection

protocol ViewModelDependency{
    func getMealList(completion: @escaping ([Meal], Error?) -> Void)
    func getMealDetails(withMealId: String, completion: @escaping (MealDetail?, Error?) -> Void)
    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void))
}

class ViewModelDependencyClass: ViewModelDependency{ //TODO: check for dependency injection in open source projects
    func getMealList(completion: @escaping ([Meal], Error?) -> Void) {}
    func getMealDetails(withMealId: String, completion: @escaping (MealDetail?, Error?) -> Void){}
    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void)) {}
}

//MARK: ViewModel
class ViewModel: ViewModelDependency {

    var displayMealList = [Meal]()
    var currentDetailObject: MealDetail?
    private let dependency: ViewModelDependency
    private let networkHandler: NetworkHandler
    private var originalMealList = [Meal]()

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
    //Future scope: Create a network interface class. This would be only necessary if there are a lot of changes in the model from the server response. I believe it will be better to have a dedicated class for that purpose.


    func getMealList(completion: @escaping ([Meal], Error?) -> Void) {

        networkHandler.makeAPICall(with: APIEndpoints.getMeals.url){
            (response:MealDTO<[MealObjectFromServer]>?, error) in
            //DEBUG:
            DispatchQueue.main.async {
                let debug = debug().getMeals()
                self.storeAndSortCurrentMealObject(response: debug)
                completion(self.displayMealList, nil)
            }
//            if error != nil {
//                completion([Meal](), error)
//                return
//            }
//            DispatchQueue.main.async {
//                self.storeAndSortCurrentMealObject(response: response?.meals ?? [])
//                completion(self.displayMealList, nil)
//            }
        }
    }

    func getMealDetails(withMealId: String, completion: @escaping (MealDetail?, Error?) -> Void){

        networkHandler.makeAPICall(
            with: APIEndpoints.getMealDetails(withMealId).url
        ){ (response:MealDTO<[MealDetailsObjectFromServer]>?, error) in

            //DEBUG:
            DispatchQueue.main.async {
                let debug = debug().getDetails()
                self.storeCurrentDetailObject(response: debug)
                completion(self.currentDetailObject!, nil)
            }

//            guard error == nil
//            else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            DispatchQueue.main.async {
//                self.storeCurrentDetailObject(response: response!.meals[0])
//                completion(self.currentDetailObject!, nil)
//            }
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
