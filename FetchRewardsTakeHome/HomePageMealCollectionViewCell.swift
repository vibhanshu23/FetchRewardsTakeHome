//
//  HomePageMealCollectionViewCell.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//

import UIKit

class HomePageMealCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgItem: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with meal:Meal){

        self.lblName.text = meal.name
        self.imgItem.image = meal.image

    }
    

}
