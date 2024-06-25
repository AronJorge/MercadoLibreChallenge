//
//  SitePresenter.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 23/06/24.
//

import Foundation

class SitePresenter {
    private let repository: SiteRepositoryProtocol
    private weak var delegate: SiteProtocol?
    
    init(repository: SiteRepositoryProtocol = SiteRepository(), delegate: SiteProtocol) {
        self.repository = repository
        self.delegate = delegate
    }
    
    @MainActor
    func getSites() async {
        do {
            let sites = try await repository.getSites()
            delegate?.setSites(sites: sites)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
