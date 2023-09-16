//
//  ViewModel.swift
//  TheMealDB
//
//  Created by Vibhanshu Jain on 4/3/23.
//
//  This file contains:
//  The buisiness logic to convert the network object to the inferface object
//  It will/or have the updated model for the UI

import Foundation
import UIKit

protocol ViewModelService{
    func getMealList(completion: @escaping ([Meal], NetworkError?) -> Void)
    func getMealDetails(withMealId: String, completion: @escaping (MealDetail?, NetworkError?) -> Void)
    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void))
    var displayMealList: [Meal] {get set}
    var currentDetailObject: MealDetail? {get set}
}


class ViewModel: ViewModelService {

    var displayMealList = [Meal]()
    var currentDetailObject: MealDetail?
    private let networkService: NetworkService
    private let imageService: ImageLoader
    private var originalMealList = [Meal]()

    init(networkService service: NetworkService = NetworkHandler()){
        self.networkService = service
        self.imageService = ImageLoader(networkService: service)
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

    func getMealList(completion: @escaping ([Meal], NetworkError?) -> Void) {
        networkService.makeAPICall(with: APIEndpoints.getMeals){
            (response:MealDTO<[MealObjectFromServer]>?, error) in

            guard error != nil || response != nil else{
                completion([Meal](), error)
                return
            }
            DispatchQueue.main.async {
                self.storeAndSortCurrentMealObject(response: response?.meals ?? [])
                completion(self.displayMealList, nil)
            }
        }
    }

    func getMealDetails(withMealId: String, completion: @escaping (MealDetail?, NetworkError?) -> Void){
        networkService.makeAPICall(
            with: APIEndpoints.getMealDetails(withMealId)
        ){ (response:MealDTO<[MealDetailsObjectFromServer]>?, error) in

            guard error == nil, let response = response
            else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                self.storeCurrentDetailObject(response: response.meals[0])
                completion(self.currentDetailObject!, nil)
            }
        }
    }

    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void)) {
        imageService.getImage(forUrl: url, completion: completion)
    }
}
