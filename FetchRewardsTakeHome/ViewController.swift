//
//  ViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let viewModel = MealViewModel()
        viewModel.getMealList { arrMeals in
            for item in arrMeals{
                print(item)
            }
        }
        viewModel.getMealDetails { arrMealDetail in
            print(arrMealDetail)
        }
    }


}

