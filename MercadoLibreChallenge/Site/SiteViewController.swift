//
//  SiteViewController.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 23/06/24.
//

import UIKit

class SiteViewController : UIViewController {
    private lazy var presenter = SitePresenter(delegate: self)
    private var sites: [Site] = []
    private var closeButtonHeightConstraint: NSLayoutConstraint?
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier.siteCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("close".localized, for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = closeButton.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        closeButtonHeightConstraint = heightConstraint
        return closeButton
    }()
    
    private lazy var selectUbicationLabel: UILabel = {
        let label = UILabel()
        label.text = "select_location".localized
        label.textColor = .blue
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    var isCloseButtonVisible: Bool {
        get { !closeButton.isHidden }
        set {
            closeButton.isHidden = !newValue
            closeButtonHeightConstraint?.constant = newValue ? 50 : 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await presenter.getSites()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCloseButtonVisible = !isRootViewController()
    }
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [closeButton, selectUbicationLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            
            selectUbicationLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            selectUbicationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectUbicationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: selectUbicationLabel.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
    
    func isRootViewController() -> Bool {
        return self == self.view.window?.rootViewController
    }
    
    func handleNavigation() {
        if isRootViewController() {
            navigateToHome()
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func navigateToHome() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            let homeViewController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            })
        }
    }

    
    private func showAlertWithError(error: Error) {
        let retryAction = AlertManager.shared.action(title: "retry".localized, style: .default) {
            self.retryFetchingSites()
        }
        
        let cancelAction = AlertManager.shared.action(title: "cancel".localized, style: .cancel)
        
        AlertManager.shared.showAlert(on: self,
                                      title: "Error".localized,
                                      message: "an_error_occurred".localized,
                                      actions: [retryAction, cancelAction])
    }
    
    private func retryFetchingSites() {
        Task {
            await presenter.getSites()
        }
    }
}

extension SiteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier.siteCell, for: indexPath)
        let site = sites[indexPath.row]
        cell.textLabel?.text = "\(site.name) (\(site.currency))"
        return cell
    }
}

extension SiteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSite = sites[indexPath.row]
        UserPreferences.saveSiteId(selectedSite.id)
        handleNavigation()
    }
}

extension SiteViewController : SiteProtocol {
    func setSites(sites: [Site]) {
        self.sites = sites
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: any Error) {
        DispatchQueue.main.async {
            self.showAlertWithError(error: error)
        }
    }
}

