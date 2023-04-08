//
//  BaseViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/4/23.
//
//  This class serves as the base class to any view controller in this application.
//  Currently the purpose is scoped to show/remove error/loading screens

protocol BaseViewControllerProtocol {
    func onClickRetryAction()
    func onClickCloseAction()
}

import UIKit

class BaseViewController: UIViewController {


    var isLoadingScreenShowing = false
    var isErrorScreenShowing = false

    let vwLoadingScreen: UIView = {
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

    let lblError: UILabel = {
        let errorLabel = UILabel()
        errorLabel.text = "Oops! Something went wrong."
        errorLabel.font = UIFont.boldSystemFont(ofSize: 24)
        errorLabel.textColor = .white
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        return errorLabel
    }()

    lazy var btnRetry: UIButton = {
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.tintColor = .white
        retryButton.addTarget(self, action: #selector(onClickRetry), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.layer.borderWidth = 0.5
        retryButton.layer.borderColor = UIColor.white.cgColor

        return retryButton
    }()

    lazy var btnClose: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(onClickCloseError), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(
            UIImage(systemName: "xmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))!,
            for: .normal
        )
        closeButton.setTitle("", for: .normal)
        return closeButton
    }()

    lazy var vwErrorScreen: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.9)

        let errorImageView = UIImageView(image: UIImage(systemName: "bonjour", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))!)
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.tintColor = .white//.withAlphaComponent(0.2)

        view.addSubview(errorImageView)
        view.addSubview(lblError)
        view.addSubview(btnClose)
        view.addSubview(btnRetry)

        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -160),
            lblError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            lblError.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            lblError.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            btnClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            btnClose.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btnRetry.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnRetry.topAnchor.constraint(equalTo: lblError.bottomAnchor, constant: 180)
        ])

        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Methods

    func showLoadingScreen() {
        hideContent()
        isLoadingScreenShowing = true
        view.addSubview(vwLoadingScreen)
        vwLoadingScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vwLoadingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            vwLoadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwLoadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vwLoadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    func showError(
        error:String,
        withRetryButton isShowingRetry:Bool = false
    ){
        hideContent()
        isErrorScreenShowing = true
        lblError.text = error
        btnRetry.isHidden = !isShowingRetry
        btnClose.isHidden = isShowingRetry
        view.addSubview(vwErrorScreen)
        vwErrorScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vwErrorScreen.topAnchor.constraint(equalTo: view.topAnchor),
            vwErrorScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwErrorScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vwErrorScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func showContent(){
        hideErrorScreen()
        hideLoadingScreen()
    }
    func hideContent(){
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
        vwErrorScreen.removeFromSuperview()
    }
    private func hideLoadingScreen() {
        isLoadingScreenShowing = false
        vwLoadingScreen.removeFromSuperview()
    }
}
