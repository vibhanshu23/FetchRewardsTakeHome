//
//  DetailViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//

import UIKit

class DetailViewController: BaseViewController {


    //TODO: Test on smaller screens

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblIngredients: UITableView!
    @IBOutlet weak var lblInstructions: UILabel!
    var isInstructionsExpanded = false

    @IBOutlet weak var scrollView: UIScrollView!
    var mealDetail: MealDetail?
    let mealId: String

    var viewModel = ViewModel()

    init(mealId: String){
        self.mealId = mealId
        mealDetail = nil
        viewModel = ViewModel()
        super.init(nibName: "DetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tblIngredients.delegate = self
        tblIngredients.dataSource = self
        tblIngredients.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblIngredients.isScrollEnabled = false


        lblName.text = mealDetail?.name
        lblInstructions.text = mealDetail?.instructions
        lblInstructions.numberOfLines = 3


        let tap = UITapGestureRecognizer(target: self, action: #selector(showMore))
        lblInstructions.addGestureRecognizer(tap)

        reloadScrollViewContent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkLabelHeight()
    }

    @objc func showMore() {
        if !isInstructionsExpanded {
            lblInstructions.numberOfLines = 0
        }
        else {
            lblInstructions.numberOfLines = 3
        }
        isInstructionsExpanded = !isInstructionsExpanded
        reloadScrollViewContent()
    }

    func checkLabelHeight() {
        lblInstructions.layoutIfNeeded()
        let labelHeight = lblInstructions.frame.size.height
        let fontHeight = lblInstructions.font.lineHeight
        let maximumHeight = fontHeight * 3.0
        if labelHeight > maximumHeight {
            lblInstructions.isUserInteractionEnabled = true
        } else {
            lblInstructions.isUserInteractionEnabled = false
        }
    }

    func reloadScrollViewContent(){
            scrollView.contentSize = CGSize(
                width: self.view.bounds.width,
                height: scrollView.contentSize.height + tblIngredients.bounds.height
            )
    }

    func fetchDataFromServer(){
        viewModel.getMealDetails(withMealId: mealId) { mealDetail, error in

            guard let mealDetail = mealDetail, error == nil else {
                self.showError(error: error?.localizedDescription ?? "Some unknown Error Occured")
                return
            }

            self.checkLabelHeight()
            self.mealDetail = mealDetail
            //FIXME: theMealDB is down. Testing pending
        }
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.mealDetail?.ingredients.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.mealDetail?.ingredients[indexPath.row].displayName
        return cell
    }



}
