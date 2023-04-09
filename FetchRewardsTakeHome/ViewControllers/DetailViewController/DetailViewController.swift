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
    @IBOutlet weak var vwScroll: UIScrollView!
    var isInstructionsExpanded = false

    let mealId: String

    var viewModel = ViewModel()

    init(mealId: String){
        self.mealId = mealId
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(showMore))
        lblInstructions.addGestureRecognizer(tap)
        fetchDataFromServer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkLabelHeight()
    }

    @objc func showMore() {
        lblInstructions.layoutIfNeeded()

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
        var height = 0.0
        for viewItem in vwScroll.subviews{
            if viewItem is UITableView{
                continue
            }
            else if viewItem is UILabel{
                let modifiedHeight = viewItem.frame.minX + viewItem.intrinsicContentSize.height
                if modifiedHeight > height{
                    height = modifiedHeight
                }
            }
        }
        height = height + tblIngredients.contentSize.height
        vwScroll.contentSize = CGSize(width: self.view.frame.width, height: height)
        vwScroll.layoutIfNeeded()
        view.layoutIfNeeded()

    }

    override func showContent(){
        super.showContent()

        lblName.text = viewModel.currentDetailObject?.name
        lblInstructions.text = viewModel.currentDetailObject?.instructions
        lblInstructions.numberOfLines = 3
        tblIngredients.reloadData()
        
        self.checkLabelHeight()
        reloadScrollViewContent()
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
