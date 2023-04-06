//
//  Constants.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation
import UIKit

let BASEURL = "https://themealdb.com/api/json/v1/1/"
let MEALSURL = BASEURL + "filter.php?c=Dessert"
let MEALDETAILSURL = BASEURL + "lookup.php?i="

class Utilities{
    static func getDefaultImage() -> UIImage{
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40)
        return UIImage(systemName: "bonjour", withConfiguration: symbolConfig)!
    }
}


extension String{
    func checkNull() -> String?{
        if self == "" {
            return nil
        }
        else{
            return self
        }
    }
}

extension UILabel {
    func textDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}

