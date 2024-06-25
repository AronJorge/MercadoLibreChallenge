//
//  HomePresenter.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

class HomePresenter {
    private let repository: HomeRepositoryProtocol
    private weak var delegate: HomeProtocol?
    
    init(repository: HomeRepositoryProtocol = HomeRepository(), delegate: HomeProtocol) {
        self.repository = repository
        self.delegate = delegate
    }
    
    @MainActor
    func searchproducts(_ search: String) async {
        if (search.isEmpty) {
            return
        }
        
        do {
            let item = try await repository.searchProduct(search)
            loadData(item)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    private func loadData(_ item: Item) {
        delegate?.setTotalProducts(item.paging.total)
        delegate?.setProducts(item.products)
    }
}
