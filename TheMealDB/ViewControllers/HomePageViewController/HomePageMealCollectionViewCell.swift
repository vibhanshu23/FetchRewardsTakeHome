//
//  HomePageMealCollectionViewCell.swift
//  TheMealDB
//
//  Created by Vibhanshu Jain on 4/4/23.
//
//  This is the HomePageMealCollectionViewCell

import UIKit

class HomePageMealCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    var service: ViewModelService?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgItem.alpha = 0.6
        imgItem.contentMode = .scaleAspectFill
        imgItem.layer.cornerRadius = 8
        imgItem.clipsToBounds = true

        lblName.textColor = .white
        lblName.numberOfLines = 0
        lblName.textAlignment = .center
        lblName.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lblName.textDropShadow()

        service = ViewModel()

    }

    func configure(with meal:Meal){
        self.lblName.text = meal.name
        self.imgItem.image = meal.image

        if meal.imageURL != "", !meal.isImageDownloaded {
            service?.getImageFor(url: meal.imageURL) { image in
                meal.updateMealWithImage(image: image)
                self.lblName.text = meal.name
                self.imgItem.image = image
            }
        }
    }

}
