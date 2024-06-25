//
//  ProductPresenter.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//


class ProductPresenter {
    private weak var delegate: ProductProtocol?
    
    init(delegate: ProductProtocol) {
        self.delegate = delegate
    }
}
