//
//  ViewController.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import UIKit

class HomeViewController: UIViewController {
    private lazy var presenter = HomePresenter(delegate: self)
    
    private lazy var searchHeaderView: SearchHeaderView = {
        let view = SearchHeaderView()
        view.delegate = self
        return view
    }()
    
    private lazy var totalResultHeaderView: TotalResultHeaderView = {
        let view = TotalResultHeaderView()
        return view
    }()
    
    private lazy var productViewController: ProductViewController = {
        let tableViewController = ProductViewController()
        tableViewController.delegate = self
        return tableViewController
    }()
    
    private lazy var resultNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: productViewController)
        return navigationController
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchHeaderView, totalResultHeaderView, resultNavigationController.view])
        stackView.axis = .vertical
        return stackView
    }()
    
    private var searchHeaderViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        search()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            let isLandscape = UIDevice.current.orientation.isLandscape
            let newHeight = isLandscape ? 80 : 100
            self.searchHeaderViewHeightConstraint?.constant = CGFloat(newHeight)
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: Constants.colors.primary)
        self.addChild(resultNavigationController)
        view.addSubview(mainStackView)
        
        resultNavigationController.didMove(toParent: self)
        
        setupConstraints()
        searchHeaderView.onUbication = {
            let siteViewController = SiteViewController()
            siteViewController.modalPresentationStyle = .overFullScreen
            self.present(siteViewController, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let initialHeight = self.traitCollection.verticalSizeClass == .compact ? 80 : 100
        searchHeaderViewHeightConstraint = searchHeaderView.heightAnchor.constraint(equalToConstant: CGFloat(initialHeight))
        
        searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchHeaderViewHeightConstraint!
        ])
        
        
        totalResultHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalResultHeaderView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            totalResultHeaderView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            totalResultHeaderView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        resultNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultNavigationController.view.topAnchor.constraint(equalTo: totalResultHeaderView.bottomAnchor),
            resultNavigationController.view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            resultNavigationController.view.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            resultNavigationController.view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    
    private func search(text: String = "", offset: Int = 0) {
        Task {
            await presenter.searchproducts(text)
        }
    }
    
    private func showAlertWithError(error: Error) {   
        let cancelAction = AlertManager.shared.action(title: "accept".localized, style: .cancel)
        
        AlertManager.shared.showAlert(on: self,
                                      title: "Error".localized,
                                      message: "an_error_occurred".localized,
                                      actions: [cancelAction])
    }
}

extension HomeViewController: ProductViewControllerDelegate {
    func resultTableControllerItemDidSelected(item: Product) {
        let detailVC = ProductDetailViewController()
        detailVC.product = item
        
        if let navigationController = self.navigationController {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.tintColor = UIColor.blue
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}

extension HomeViewController: SearchHeaderViewDelegate {
    func searchHeaderViewDidEndSearch(withText text: String) {
        search(text: text, offset: 0)
    }
}

extension HomeViewController: HomeProtocol {
    func setProducts(_ products: [Product]) {
        productViewController.configure(with: products)
    }
    
    func setTotalProducts(_ totalResults: Int) {
        totalResultHeaderView.setResults(numberOfItems: totalResults)
    }
    
    func didFailWithError(error: any Error) {
        showAlertWithError(error: error)
    }
}
