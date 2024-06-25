//
//  HomeProtocol.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

protocol HomeProtocol: AnyObject {
    func setTotalProducts(_ totalResults: Int)
    func setProducts(_ products: [Product])
    func didFailWithError(error: Error)
}
