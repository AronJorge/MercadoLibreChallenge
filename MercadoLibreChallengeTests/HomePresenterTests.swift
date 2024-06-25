//
//  HomePresenterTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import XCTest
@testable import MercadoLibreChallenge

final class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var mockRepository: MockHomeRepository!
    var mockDelegate: MockHomeDelegate!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockHomeRepository()
        mockDelegate = MockHomeDelegate()
        presenter = HomePresenter(repository: mockRepository, delegate: mockDelegate)
    }
    
    override func tearDown() {
        presenter = nil
        mockRepository = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testSearchProductsWithNonEmptyQuerySuccess() async {
        let expectedProduct = Product(id: "1", title: "Test Product", condition: nil, catalogProductID: nil, permalink: "", buyingMode: nil, siteID: nil, categoryID: nil, domainID: nil, thumbnail: "", currencyID: "", price: 0, attributes: [], pictures: [])
        mockRepository.mockResult = .success(Item(siteId: "1", query: "Test", paging: Paging(total: 1, primaryResults: 1, offset: 0, limit: 10), products: [expectedProduct]))
        
        await presenter.searchproducts("Test")
        
        XCTAssertEqual(mockDelegate.productsReceived?.count, 1)
        XCTAssertEqual(mockDelegate.productsReceived?.first?.title, "Test Product")
    }
    
    func testSearchProductsWithEmptyQuery() async {
        let searchQuery = ""
        await presenter.searchproducts(searchQuery)
        XCTAssertNil(mockDelegate.productsReceived)
    }
    
    func testSearchProductsWithNonEmptyQueryFailure() async {
        mockRepository.mockResult = .failure(NSError(domain: "", code: 0, userInfo: nil))
        await presenter.searchproducts("Test")
        XCTAssertNotNil(mockDelegate.errorReceived)
    }
}


class MockHomeRepository: HomeRepositoryProtocol {
    var mockResult: Result<Item, Error>?
    
    func searchProduct(_ search: String) async throws -> Item {
        if let result = mockResult {
            switch result {
            case .success(let item):
                return item
            case .failure(let error):
                throw error
            }
        }
        throw NSError(domain: "Not implemented", code: 0, userInfo: nil)
    }
}

class MockHomeDelegate: HomeProtocol {
    var productsReceived: [Product]?
    var errorReceived: Error?
    
    func setTotalProducts(_ totalResults: Int) {
    }
    
    func setProducts(_ products: [Product]) {
        productsReceived = products
    }
    
    func didFailWithError(error: Error) {
        errorReceived = error
    }
}
