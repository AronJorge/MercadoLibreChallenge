//
//  ProductDetailPresenter.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import Foundation


class ProductDetailViewPresenter {
    private let repository: ProductRepositoryProtocol
    private weak var delegate: ProductDetailProtocol?

    init(repository: ProductRepositoryProtocol = ProductRepository(), delegate: ProductDetailProtocol) {
        self.repository = repository
        self.delegate = delegate
    }
 
    @MainActor
    func getProductDetail(itemId: String) async {
        do {
            let product = try await repository.getProduct(itemId)
            loadData(product)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    private func loadData(_ product: Product) {
        delegate?.setTitle(title: product.title)
        delegate?.setPrice(price: String(format: "currency_format".localized, product.price))
        delegate?.setThumbnail(thumbnail: product.pictures?.first?.secureURL ?? product.thumbnail)
        delegate?.setProduct(productDetail: product)
    }
}
