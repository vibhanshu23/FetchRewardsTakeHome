//
//  Meal.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation
import UIKit

enum MealCategory {
    case dessert
}
//FUTER Scope it for different categories

//MARK: server models
struct MealDTO<T:Codable>: Codable { //The Data Transfer Object
    var meals: T
}

struct MealObjectFromServer: Codable, Equatable{

    let name: String
    let imageURL: String
    let id: String

    enum CodingKeys: String, CodingKey{
        case name = "strMeal"
        case imageURL = "strMealThumb"
        case id = "idMeal"
    }

    func getInterfaceObject () -> Meal{
        return Meal(
            name: self.name,
            imageURL: self.imageURL,
            id: self.id,
            image: nil
        )
    }
}

struct MealDetailsObjectFromServer: Codable {
    let id: String
    let name: String
    let instructions: String

    let ingredient1: String?
    let ingredient2: String?
    let ingredient3: String?
    let ingredient4: String?
    let ingredient5: String?
    let ingredient6: String?
    let ingredient7: String?
    let ingredient8: String?
    let ingredient9: String?
    let ingredient10: String?
    let ingredient11: String?
    let ingredient12: String?
    let ingredient13: String?
    let ingredient14: String?
    let ingredient15: String?
    let ingredient16: String?
    let ingredient17: String?
    let ingredient18: String?
    let ingredient19: String?
    let ingredient20: String?
    let measurement1: String?
    let measurement2: String?
    let measurement3: String?
    let measurement4: String?
    let measurement5: String?
    let measurement6: String?
    let measurement7: String?
    let measurement8: String?
    let measurement9: String?
    let measurement10: String?
    let measurement11: String?
    let measurement12: String?
    let measurement13: String?
    let measurement14: String?
    let measurement15: String?
    let measurement16: String?
    let measurement17: String?
    let measurement18: String?
    let measurement19: String?
    let measurement20: String?

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"

        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"

        case measurement1 = "strMeasure1"
        case measurement2 = "strMeasure2"
        case measurement3 = "strMeasure3"
        case measurement4 = "strMeasure4"
        case measurement5 = "strMeasure5"
        case measurement6 = "strMeasure6"
        case measurement7 = "strMeasure7"
        case measurement8 = "strMeasure8"
        case measurement9 = "strMeasure9"
        case measurement10 = "strMeasure10"
        case measurement11 = "strMeasure11"
        case measurement12 = "strMeasure12"
        case measurement13 = "strMeasure13"
        case measurement14 = "strMeasure14"
        case measurement15 = "strMeasure15"
        case measurement16 = "strMeasure16"
        case measurement17 = "strMeasure17"
        case measurement18 = "strMeasure18"
        case measurement19 = "strMeasure19"
        case measurement20 = "strMeasure20"
    }

    func getInterfaceObject () -> MealDetail{

        var finalArr = [Ingredient]()

        if let ingredient1 = self.ingredient1?.checkNull(),  let measurement1 = self.measurement1?.checkNull() {
            finalArr.append(Ingredient(name: ingredient1, quantity: measurement1))
        }
        if let ingredient2 = self.ingredient2?.checkNull(), let measurement2 = self.measurement2?.checkNull() {
            finalArr.append(Ingredient(name: ingredient2, quantity: measurement2))
        }
        if let ingredient3 = self.ingredient3?.checkNull(),  let measurement3 = self.measurement3?.checkNull() {
            finalArr.append(Ingredient(name: ingredient3, quantity: measurement3))
        }
        if let ingredient4 = self.ingredient4?.checkNull(),  let measurement4 = self.measurement4?.checkNull() {
            finalArr.append(Ingredient(name: ingredient4, quantity: measurement4))
        }
        if let ingredient5 = self.ingredient5?.checkNull(),  let measurement5 = self.measurement5?.checkNull() {
            finalArr.append(Ingredient(name: ingredient5, quantity: measurement5))
        }
        if let ingredient6 = self.ingredient6?.checkNull(),  let measurement6 = self.measurement6?.checkNull() {
            finalArr.append(Ingredient(name: ingredient6, quantity: measurement6))
        }
        if let ingredient7 = self.ingredient7?.checkNull(),  let measurement7 = self.measurement7?.checkNull() {
            finalArr.append(Ingredient(name: ingredient7, quantity: measurement7))
        }
        if let ingredient8 = self.ingredient8?.checkNull(),  let measurement8 = self.measurement8?.checkNull() {
            finalArr.append(Ingredient(name: ingredient8, quantity: measurement8))
        }
        if let ingredient9 = self.ingredient9?.checkNull(),  let measurement9 = self.measurement9?.checkNull() {
            finalArr.append(Ingredient(name: ingredient9, quantity: measurement9))
        }
        if let ingredient10 = self.ingredient10?.checkNull(),  let measurement10 = self.ingredient10?.checkNull() {
            finalArr.append(Ingredient(name: ingredient10, quantity: measurement10))
        }
        if let ingredient11 = self.ingredient11?.checkNull(),  let measurement11 = self.measurement11?.checkNull() {
            finalArr.append(Ingredient(name: ingredient11, quantity: measurement11))
        }
        if let ingredient12 = self.ingredient12?.checkNull(),  let measurement12 = self.measurement12?.checkNull() {
            finalArr.append(Ingredient(name: ingredient12, quantity: measurement12))
        }
        if let ingredient13 = self.ingredient13?.checkNull(),  let measurement13 = self.measurement13?.checkNull() {
            finalArr.append(Ingredient(name: ingredient13, quantity: measurement13))
        }
        if let ingredient14 = self.ingredient14?.checkNull(),  let measurement14 = self.measurement14?.checkNull() {
            finalArr.append(Ingredient(name: ingredient14, quantity: measurement14))
        }
        if let ingredient15 = self.ingredient15?.checkNull(),  let measurement15 = self.measurement15?.checkNull() {
            finalArr.append(Ingredient(name: ingredient15, quantity: measurement15))
        }
        if let ingredient16 = self.ingredient16?.checkNull(),  let measurement16 = self.measurement16?.checkNull() {
            finalArr.append(Ingredient(name: ingredient16, quantity: measurement16))
        }
        if let ingredient17 = self.ingredient17?.checkNull(),  let measurement17 = self.measurement17?.checkNull() {
            finalArr.append(Ingredient(name: ingredient17, quantity: measurement17))
        }
        if let ingredient18 = self.ingredient18?.checkNull(),  let measurement18 = self.measurement18?.checkNull() {
            finalArr.append(Ingredient(name: ingredient18, quantity: measurement18))
        }
        if let ingredient19 = self.ingredient19?.checkNull(),  let measurement19 = self.measurement19?.checkNull() {
            finalArr.append(Ingredient(name: ingredient19, quantity: measurement19))
        }
        if let ingredient20 = self.ingredient20?.checkNull(),  let measurement20 = self.measurement20?.checkNull() {
            finalArr.append(Ingredient(name: ingredient20, quantity: measurement20))
        }



        let localObjectCopy = MealDetail(
            name: self.name,
            instructions: self.instructions,
            ingredients: finalArr,
            image: nil
        )
        return localObjectCopy
    }

    


}

//MARK: Local Models

class Meal: Equatable{
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return true
        //FIXME:
    }


    let name: String
    let imageURL: String
    let id: String
    var image: UIImage = Utilities.getDefaultImage()
    var isImageDownloaded = false

    init(name: String, imageURL: String, id: String, image: UIImage?) {
        self.name = name
        self.imageURL = imageURL
        self.id = id
        if let image = image {
            self.image = image
        }

    }

    func updateMealWithImage(image: UIImage){
        self.image = image
        self.isImageDownloaded = true
    }

}

class MealDetail : Equatable{
    static func == (lhs: MealDetail, rhs: MealDetail) -> Bool {
        return true
        //FIXME:
    }

    let name: String
    let instructions: String
    var ingredients = [Ingredient]() //Future Scope - Error handling for null array
    var image: UIImage

    init(name: String, instructions: String, ingredients: [Ingredient], image: UIImage? = nil) {
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40)
        self.image = image ?? UIImage(systemName: "bonjour", withConfiguration: symbolConfig)!
        //future scope create UIImage asset class
}

}

class Ingredient {
    let name: String
    let quantity: String
    let displayName: String

    init(name: String, quantity: String) {
        self.name = name
        self.quantity = quantity
        self.displayName = quantity + " | " + name
    }
}

