//
//  SiteProtocol.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 23/06/24.
//

import Foundation

protocol SiteProtocol: AnyObject {
    func setSites(sites: [Site])
    func didFailWithError(error: Error)
}
