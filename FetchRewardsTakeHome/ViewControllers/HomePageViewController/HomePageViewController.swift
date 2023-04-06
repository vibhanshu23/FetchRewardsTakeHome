//
//  HomePageViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//

import UIKit


class HomePageViewController: BaseViewController {

    @IBOutlet weak var cvMealList: UICollectionView!
    
    let viewModel = ViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        cvMealList.delegate = self
        cvMealList.dataSource = self
        cvMealList.register(
            UINib(nibName: "HomePageMealCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HomePageMealCollectionViewCell"
        )
        let flowLayout = UICollectionViewFlowLayout()
        cvMealList.collectionViewLayout = flowLayout

        fetchDataFromServer()

    }

    func fetchDataFromServer(){
        showLoadingScreen()
        viewModel.getMealList { arrMeals, error in
//            self.debug() //DEBUG
            guard error == nil else {
                self.showError(
                    error: error?.localizedDescription ?? "Some unknown Error Occured",
                    withRetryButton: true
                )
                return
            }
            self.showContent()
            self.cvMealList.reloadData()
        }
    }

    @objc override func onClickRetry(){
        fetchDataFromServer()
    }

    //MARK: Debug
    func debug(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showLoadingScreen()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showError(error: "With Retry Button",withRetryButton: true )
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showError(error: "Without Retry", withRetryButton: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.showContent()
                    }
                }
            }
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
        _ = self.viewModel.displayMealList[indexPath.row]

        showLoadingScreen()
        viewModel.getMealDetails { mealDetail, error in

            guard let mealDetail = mealDetail, error == nil else {
                self.showError(error: error?.localizedDescription ?? "Some unknown Error Occured")
                return
            }
            self.navigationController?.pushViewController(
                DetailViewController(mealDetail: mealDetail),
                animated: true
            )

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

}
