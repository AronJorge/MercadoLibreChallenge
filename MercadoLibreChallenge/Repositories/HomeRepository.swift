//
//  WeatherRepository.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 22/06/24.
//

protocol HomeRepositoryProtocol {
    func searchProduct(_ search: String) async throws -> Item
}

class HomeRepository: HomeRepositoryProtocol {
    func searchProduct(_ search: String) async throws -> Item {
        let siteId = UserPreferences.getSiteId()
        
        let request = RequestModel(endpoint: .search(siteId: siteId!, query: search))
        
        do{
            let model = try await APIConnection.callService(request, Item.self)
            return model
        }catch{
            throw error
        }
    }
}
