//
//  HomeProtocol.swift
//  Weather Webcat
//
//  Created by Jorge Gutierrez on 19/03/23.
//

protocol HomeProtocol: AnyObject {
    func setTotalProducts(_ totalResults: Int)
    func setProducts(_ products: [Product])
    func didFailWithError(error: Error)
}
