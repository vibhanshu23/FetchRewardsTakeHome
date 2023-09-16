//
//  DetailViewController.swift
//  TheMealDB
//
//  Created by Vibhanshu Jain on 4/4/23.
//

import UIKit

class DetailViewController: BaseViewController {


    //TODO: Test on smaller screens

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblIngredients: UITableView!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var vwScroll: UIScrollView!
    var isInstructionsExpanded = false

    let mealId: String

    var viewModel: ViewModelService

    init(mealId: String, andViewModelService viewModel: ViewModelService = ViewModel()){
        self.mealId = mealId
        self.viewModel = viewModel
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

        lblInstructions.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMore))
        lblInstructions.addGestureRecognizer(tap)

        fetchDataFromServer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    @objc func showMore() {

        isInstructionsExpanded = !isInstructionsExpanded
        checkLabelHeight()
    }

    func checkLabelHeight() {
        let maxLines = isInstructionsExpanded ? 0 : 3

        lblInstructions.numberOfLines = maxLines
        lblInstructions.layoutIfNeeded()
        vwScroll.layoutIfNeeded()
        view.layoutIfNeeded()

    }

    func reloadScrollViewContent(){
        vwScroll.layoutIfNeeded()
        view.layoutIfNeeded()

    }

    override func showContent(){
        super.showContent()

        lblName.text = viewModel.currentDetailObject?.name
        lblInstructions.text = viewModel.currentDetailObject?.instructions
        lblInstructions.numberOfLines = 3
        tblIngredients.reloadData()

    }

    override func onClickCloseError() {
        super.onClickCloseError()
        self.navigationController?.popViewController(animated: true)
    }

    func fetchDataFromServer(){
        showLoadingScreen()

        viewModel.getMealDetails(withMealId: mealId) { mealDetail, error in

            self.showContent()

            guard error == nil else {
                self.showError(error: error?.errorMessage ?? "Some unknown Error Occured")
                return
            }

            self.showContent()
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentDetailObject?.ingredients.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.currentDetailObject?.ingredients[indexPath.row].displayName
        return cell
    }
}
