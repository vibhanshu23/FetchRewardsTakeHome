//
//  HomePageViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//

import UIKit


class HomePageViewController: UIViewController {

    @IBOutlet weak var cvMealList: UICollectionView!
    
    let viewModel = ViewModel()//Future scope: dependency injection


    override func viewDidLoad() {
        super.viewDidLoad()

        cvMealList.delegate = self
        cvMealList.dataSource = self
        cvMealList.register(
            UINib(nibName: "HomePageMealCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HomePageMealCollectionViewCell"
        )
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.estimatedItemSize = CGSize(width: self.view.bounds.width, height: 100 )
        cvMealList.collectionViewLayout = flowLayout

        //Future Scope - show Loading

        viewModel.getMealList { arrMeals, error in

            guard error == nil else {
                //TODO:- ERROR HANDLING
                return
            }
            self.cvMealList.reloadData()
        }

    }

}

extension HomePageViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.displayMealList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageMealCollectionViewCell", for: indexPath) as! HomePageMealCollectionViewCell
        let item = self.viewModel.displayMealList[indexPath.row]
        cell.configure(with: item)
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.viewModel.displayMealList[indexPath.row]

        viewModel.getMealDetails { mealDetail, error in

            guard let mealDetail = mealDetail, error == nil else {
                return //TODO: Error handling
            }

            self.navigationController?.pushViewController(
                DetailViewController(mealDetail: mealDetail),
                animated: true
            )

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let cellWidth = collectionView.bounds.width
//        let cellHeight = calculateHeightForCell(at: indexPath, with: cellWidth)
        return CGSize(width: collectionView.bounds.width, height: 100)

    }

//    func calculateHeightForCell(at indexPath: IndexPath, with width: CGFloat) -> CGFloat {
//        let item = self.viewModel.displayMealList[indexPath.row]
//        let cell = self.cvMealList.cellForItem(at: indexPath) as? HomePageMealCollectionViewCell
//        cell?.contentView.layoutIfNeeded()
//        cell?.configure(with: item)
//        cell?.contentView.frame = CGRect(x: 0, y: 0, width: width, height: 0)
//        cell?.contentView.layoutIfNeeded()
//        let height = cell?.contentView.systemLayoutSizeFitting(CGSize(width: width, height: 0)).height
//        return height ?? 100
//    }









}
