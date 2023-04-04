//
//  HomePageViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//

import UIKit


class HomePageViewController: UIViewController {

    @IBOutlet weak var vwLoading: UIView!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var btnCloseError: UIButton!
    @IBOutlet weak var btnRetry: UIButton!
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

        btnCloseError.isHidden = true
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20)
        btnCloseError.setImage(
            UIImage(systemName: "xmark.circle", withConfiguration: symbolConfig)!,
            for: .normal
        )
        btnCloseError.setTitle("", for: .normal)

        btnRetry.isHidden = true

        lblLoading.textAlignment = .center
        lblLoading.numberOfLines = 0

        fetchDataFromServer()

    }

    func fetchDataFromServer(){
        showLoading()
        viewModel.getMealList { arrMeals, error in
            self.hideLoading()
            guard error == nil else {
                self.showError(
                    error: error?.localizedDescription ?? "Some unknown Error Occured",
                    withRetryButton: true
                )
                return
            }
            self.cvMealList.reloadData()
        }
    }

    func showLoading(){
        view.bringSubviewToFront(vwLoading)
        lblLoading.text = "Loading ..."
        vwLoading.isHidden = false
    }

    func hideLoading(){
        view.sendSubviewToBack(vwLoading)
        lblLoading.text = ""
        vwLoading.isHidden = true
    }

    func showError(
        error:String,
        withRetryButton isShowingRetry:Bool = false
    ){
        view.bringSubviewToFront(vwLoading)
        lblLoading.text = error
        vwLoading.isHidden = false
        if (isShowingRetry) {
            btnRetry.isHidden = false
            btnCloseError.isHidden = true
        }
        else{
            btnRetry.isHidden = true
            btnCloseError.isHidden = false
        }
    }

    func hideError(){
        btnCloseError.isHidden = true
        btnRetry.isHidden = true

        hideLoading()
    }

    @IBAction func onClickCloseError(_ sender: Any) {
        hideError()
    }
    @IBAction func onClickRetry(_ sender: Any) {
        hideError()
        fetchDataFromServer()
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

        showLoading()
        viewModel.getMealDetails { mealDetail, error in
            self.hideLoading()

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
