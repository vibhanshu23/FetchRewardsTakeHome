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
        imgItem.alpha = 0.5
        imgItem.contentMode = .scaleAspectFill

        lblName.backgroundColor = .black.withAlphaComponent(0.3)
        lblName.textColor = .white
        lblName.font = .systemFont(ofSize: 24)
        lblName.numberOfLines = 0
        
    }

    func configure(with meal:Meal){

        self.lblName.text = meal.name
        self.imgItem.image = meal.image


        if meal.imageURL != "", !meal.isImageDownloaded {
            NetworkHandler.getImageFor(url: meal.imageURL) { image in
                meal.updateMealWithImage(image: image)
                self.lblName.text = meal.name
                self.imgItem.image = image
            }

        }
    }
    

}
