//
//  ProductViewController.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import UIKit
import SDWebImage

protocol ProductViewControllerDelegate: AnyObject {
    func resultTableControllerItemDidSelected(item: Product)
}

class ProductViewController: UIViewController {
    weak var delegate: ProductViewControllerDelegate?
    private lazy var presenter = ProductPresenter(delegate: self)
    private var products: [Product] = []
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configure(with products: [Product]) {
        self.products = products
        collectionView.reloadData()
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            fatalError("Failed to dequeue a ProductCell.")
        }
        
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }

}

extension ProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        delegate?.resultTableControllerItemDidSelected(item: product)
    }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (numberOfColumns - 1)
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
}

extension ProductViewController: ProductProtocol {
    
}
