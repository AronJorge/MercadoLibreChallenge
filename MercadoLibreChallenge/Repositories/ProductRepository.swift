//
//  ProductRepository.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//


protocol ProductRepositoryProtocol {
    func getProduct(_ itemId: String) async throws -> Product
}

class ProductRepository: ProductRepositoryProtocol {
    func getProduct(_ itemId: String) async throws -> Product {
        let request = RequestModel(endpoint: .items(itemId: itemId))
        
        do{
            let model = try await APIConnection.callService(request, Product.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
}
