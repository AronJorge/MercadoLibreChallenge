//
//  SitePresenterTest.swift
//  MercadoLibreChallengeTests
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import XCTest
@testable import MercadoLibreChallenge

final class SitePresenterTest: XCTestCase {
    var mockRepository: MockSiteRepository!
    var mockDelegate: MockSiteDelegate!
    var presenter: SitePresenter!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockSiteRepository()
        mockDelegate = MockSiteDelegate()
        presenter = SitePresenter(repository: mockRepository, delegate: mockDelegate)
    }
    
    func testGetSitesSuccess() async {
        let expectedSites = [
            Site(id: "1", name: "Site1", currency: "USD"),
            Site(id: "2", name: "Site2", currency: "EUR")
        ]
        
        mockRepository.sites = expectedSites
        
        await presenter.getSites()
        XCTAssertEqual(mockDelegate.capturedSites, expectedSites, "El presentador debe comunicar los sitios correctamente al delegado.")
    }
    
    func testGetSitesFailure() async {
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRepository.error = expectedError
        
        await presenter.getSites()
        
        XCTAssertNotNil(mockDelegate.capturedError, "El presentador debe comunicar un error al delegado cuando la obtención de sitios falla.")
        XCTAssertTrue(mockDelegate.capturedError! as NSError === expectedError, "El error comunicado debe ser el mismo que el generado por el repositorio.")
    }
}


extension Site: Equatable {
    public static func == (lhs: Site, rhs: Site) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.currency == rhs.currency
    }
}

class MockSiteRepository: SiteRepositoryProtocol {
    var sites: [Site]?
    var error: Error?
    
    func getSites() async throws -> [Site] {
        if let error = error {
            throw error
        }
        return sites ?? []
    }
}

class MockSiteDelegate: SiteProtocol {
    var capturedSites: [Site]?
    var capturedError: Error?
    
    func setSites(sites: [Site]) {
        capturedSites = sites
    }
    
    func didFailWithError(error: Error) {
        capturedError = error
    }
}
