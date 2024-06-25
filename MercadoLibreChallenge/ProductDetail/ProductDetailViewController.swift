//
//  ProductDetailViewController.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import Foundation

import UIKit

class ProductDetailViewController: UIViewController {
    private lazy var presenter = ProductDetailViewPresenter(delegate: self)
    var product: Product?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attributesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureViews()
        
        Task {
            await presenter.getProductDetail(itemId:product?.id ?? "")
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubview(productImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(priceLabel)
            contentView.addSubview(attributesTableView)

            attributesTableView.dataSource = self
        attributesTableView.register(AttributeCell.self, forCellReuseIdentifier: Constants.identifier.attributeCell)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            attributesTableView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            attributesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attributesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            attributesTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            attributesTableView.heightAnchor.constraint(equalToConstant: 300) // Adjust based on content
        ])
    }
    
    private func configureViews() {
        guard let product = product else { return }
        productImageView.sd_setImage(with: URL(string: product.thumbnail))
        titleLabel.text = product.title
        priceLabel.text = String(format: "currency_format".localized, product.price)
        attributesTableView.reloadData()
    }
}

extension ProductDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product?.attributes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath)
        if let attribute = product?.attributes[indexPath.row] {
            let attributeName = attribute.name ?? "not_available".localized
            let attributeValue = attribute.valueName ?? "not_available".localized
            
            let displayText = String(format: "attribute_display".localized, attributeName, attributeValue)
            cell.textLabel?.text = displayText
        }
        return cell
    }
}


extension ProductDetailViewController: ProductDetailProtocol {
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setThumbnail(thumbnail: String) {
        productImageView.sd_setImage(with: URL(string: thumbnail))
    }
    
    func setPrice(price: String) {
        priceLabel.text = price
    }
    
    func setProduct(productDetail: Product) {
        self.product = productDetail
        attributesTableView.reloadData()
    }
    
    func didFailWithError(error: any Error) {
        let cancelAction = AlertManager.shared.action(title: "accept".localized, style: .cancel)
        
        AlertManager.shared.showAlert(on: self,
                                      title: "Error".localized,
                                      message: "an_error_occurred".localized,
                                      actions: [cancelAction])
    }
}
