//
//  ProductDetailProtocol.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

protocol ProductDetailProtocol: AnyObject {
    func setTitle(title: String)
    func setThumbnail(thumbnail: String)
    func setPrice(price: String)
    func setProduct(productDetail: Product)
    func didFailWithError(error: Error)
}
