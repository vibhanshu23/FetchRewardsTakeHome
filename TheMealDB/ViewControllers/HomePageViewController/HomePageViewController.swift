//
//  HomePageViewController.swift
//  TheMealDB
//
//  Created by Vibhanshu Jain on 4/4/23.
//
//  This is the landing home page for the application.

import UIKit

class HomePageViewController: BaseViewController {

    @IBOutlet weak var cvMealList: UICollectionView!
    @IBOutlet weak var lblDessert: UILabel!

    let viewModel: ViewModelService = ViewModel()

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

        fetchDataFromViewModel()

    }

    func fetchDataFromViewModel(){
        showLoadingScreen()
        viewModel.getMealList { arrMeals, error in
            guard error == nil, arrMeals.count != 0 else {
                self.showError(
                    error: error?.errorMessage ?? "Some unknown Error Occured",
                    withRetryButton: true
                )
                return
            }
            self.showContent()
        }
    }

    @objc override func onClickRetry(){
        fetchDataFromViewModel()
    }

    @IBAction func onClickShowErrorScreen(_ sender: Any) {
        showError(error: "This is a dummy error screen",withRetryButton: true)
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.showContent()
        }
    }
    @IBAction func onClickShowLoadingScreen(_ sender: Any) {
        showLoadingScreen()
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.showContent()
        }

    }
    override func showContent() {
        super.showContent()
        self.cvMealList.reloadData()
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
        cell.service = viewModel
        cell.configure(with: item)
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = self.viewModel.displayMealList[indexPath.row]

        self.navigationController?.pushViewController(
            DetailViewController(mealId: meal.id, andViewModelService: viewModel),
            animated: true
        )

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

}

extension HomePageViewController{

}
