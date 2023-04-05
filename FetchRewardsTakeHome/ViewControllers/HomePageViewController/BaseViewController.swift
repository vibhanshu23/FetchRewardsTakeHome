//
//  BaseViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//

protocol BaseViewControllerProtocol {
    func onClickRetryAction()
    func onClickCloseAction()
}

import UIKit

class BaseViewController: UIViewController {


    var isLoadingScreenShowing = false
    var isErrorScreenShowing = false

    let loadingScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        let loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.font = UIFont.systemFont(ofSize: 18)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8)
        ])

        activityIndicator.startAnimating()

        return view
    }()

    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.text = "Oops! Something went wrong."
        errorLabel.font = UIFont.boldSystemFont(ofSize: 24)
        errorLabel.textColor = .white
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        return errorLabel
    }()

    lazy var retryButton: UIButton = {
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.tintColor = .white
        retryButton.addTarget(self, action: #selector(onClickRetry), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        return retryButton
    }()

    lazy var errorScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .red

        let errorImageView = UIImageView(image: UIImage(named: "error"))
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorImageView)


        view.addSubview(errorLabel)


        let closeButton = UIButton(type: .system)
        //        closeButton.setTitle("Close", for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(onClickCloseError), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20)
        closeButton.setImage(
            UIImage(systemName: "xmark.circle", withConfiguration: symbolConfig)!,
            for: .normal
        )
        closeButton.setTitle("", for: .normal)
        view.addSubview(closeButton)


        view.addSubview(retryButton)

        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20)
        ])

        return view
    }()



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Methods

    func showLoadingScreen() {
        hideErrorScreen()
        isLoadingScreenShowing = true
        view.addSubview(loadingScreenView)
        loadingScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    func showError(
        error:String,
        withRetryButton isShowingRetry:Bool = false
    ){
        hideErrorScreen()
        isErrorScreenShowing = true
        errorLabel.text = error
        retryButton.isHidden = !isShowingRetry
        view.addSubview(errorScreenView)
        errorScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            errorScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func showContent(){
        hideErrorScreen()
        hideLoadingScreen()

    }

    @objc func onClickCloseError(){
        showContent()
    }

    @objc func onClickRetry(){
        showContent()
    }
    
//MARK: private members

    private func hideErrorScreen() {
        isErrorScreenShowing = false
        errorScreenView.removeFromSuperview()
    }
    private func hideLoadingScreen() {
        isLoadingScreenShowing = false
        loadingScreenView.removeFromSuperview()
    }
}
