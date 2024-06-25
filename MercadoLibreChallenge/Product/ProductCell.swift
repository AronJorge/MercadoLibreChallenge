//
//  ProductCell.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import UIKit

class ProductCell: UICollectionViewCell {
    static let identifier = Constants.identifier.productCell
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(productImageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.title
        priceLabel.text =  String(format: "currency_format".localized, product.price)
        productImageView.sd_setImage(with: URL(string: product.thumbnail))
    }
}
