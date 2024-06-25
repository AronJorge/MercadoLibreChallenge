//
//  SiteRepository.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//


protocol SiteRepositoryProtocol {
    func getSites() async throws -> [Site]
}

class SiteRepository: SiteRepositoryProtocol {
    func getSites() async throws -> [Site] {
        let request = RequestModel(endpoint: .sites)
        
        do{
            let model = try await APIConnection.callService(request, [Site].self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
}
