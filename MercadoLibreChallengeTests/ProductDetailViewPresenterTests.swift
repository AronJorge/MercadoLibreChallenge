//
//  ProductDetailViewPresenterTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import XCTest
@testable import MercadoLibreChallenge

class MockProductRepository: ProductRepositoryProtocol {
    var product: Product?
    var error: Error?

    func getProduct(_ itemId: String) async throws -> Product {
        if let error = error {
            throw error
        }
        return product!
    }
}

class MockProductDetailDelegate: ProductDetailProtocol {
    var title: String?
    var price: String?
    var thumbnail: String?
    var productDetail: Product?
    var errorReceived: Error?

    func setTitle(title: String) {
        self.title = title
    }

    func setPrice(price: String) {
        self.price = price
    }

    func setThumbnail(thumbnail: String) {
        self.thumbnail = thumbnail
    }

    func setProduct(productDetail: Product) {
        self.productDetail = productDetail
    }

    func didFailWithError(error: Error) {
        self.errorReceived = error
    }
}

let expectedProduct = Product(
    id: "123",
    title: "Test Product",
    condition: "new",
    catalogProductID: "ABC123",
    permalink: "http://example.com/product",
    buyingMode: "buy_it_now",
    siteID: "MLA",
    categoryID: "Electronics",
    domainID: "DomainID",
    thumbnail: "http://example.com/image.jpg",
    currencyID: "USD",
    price: 99.99,
    attributes: [
        Attribute(name: "Color", valueName: "Black")
    ],
    pictures: [
        Picture(url: "http://example.com/image.jpg", secureURL: "https://example.com/image.jpg")
    ]
)

final class ProductDetailViewPresenterTests: XCTestCase {
    var presenter: ProductDetailViewPresenter!
        var mockRepository: MockProductRepository!
        var mockDelegate: MockProductDetailDelegate!

        override func setUp() {
            super.setUp()
            mockRepository = MockProductRepository()
            mockDelegate = MockProductDetailDelegate()
            presenter = ProductDetailViewPresenter(repository: mockRepository, delegate: mockDelegate)
        }

        override func tearDown() {
            presenter = nil
            mockRepository = nil
            mockDelegate = nil
            super.tearDown()
        }

        func testGetProductDetailSuccess() async {
            let expectedProduct = expectedProduct
            mockRepository.product = expectedProduct

            await presenter.getProductDetail(itemId: "123")

            XCTAssertEqual(mockDelegate.title, expectedProduct.title)
            XCTAssertEqual(mockDelegate.price, String(format: "currency_format".localized, expectedProduct.price))
            XCTAssertEqual(mockDelegate.thumbnail, expectedProduct.pictures?.first?.secureURL ?? expectedProduct.thumbnail)
            XCTAssertEqual(mockDelegate.productDetail?.title, expectedProduct.title)
        }

        func testGetProductDetailFailure() async {
            let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
            mockRepository.error = expectedError

            await presenter.getProductDetail(itemId: "123")

            XCTAssertNotNil(mockDelegate.errorReceived)
        }


}
