//
//  Item.swift
//  MercadoCasiLibre
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import Foundation

struct Item: Decodable {
    let siteId: String
    let query: String?
    let paging: Paging
    let products: [Product]
    
    init(siteId: String, query: String, paging: Paging, products: [Product]) {
        self.siteId = siteId
        self.query = query
        self.paging = paging
        self.products = products
    }

    enum CodingKeys: String, CodingKey {
        case siteId = "site_id"
        case query
        case paging
        case products = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        siteId = try values.decode(String.self, forKey: .siteId)
        query = try values.decode(String?.self, forKey: .query)
        paging = try values.decode(Paging.self, forKey: .paging)
        products = try values.decode([Product].self, forKey: .products)
    }
}

// MARK: - Paging
struct Paging: Codable {
    let total, primaryResults, offset, limit: Int

    init(total: Int, primaryResults: Int, offset: Int, limit: Int) {
        self.total = total
        self.primaryResults = primaryResults
        self.offset = offset
        self.limit = limit
    }
    
    enum CodingKeys: String, CodingKey {
        case total
        case primaryResults = "primary_results"
        case offset, limit
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decode(Int.self, forKey: .total)
        primaryResults = try values.decode(Int.self, forKey: .primaryResults)
        offset = try values.decode(Int.self, forKey: .offset)
        limit = try values.decode(Int.self, forKey: .limit)
    }
}


// MARK: - Product
struct Product: Codable {
    let id, title: String
    let condition, catalogProductID: String?
    let permalink: String
    let buyingMode, siteID, categoryID, domainID: String?
    let thumbnail: String
    let currencyID: String
    let price: Float
    let attributes: [Attribute]
    let pictures: [Picture]?

    init(id: String, title: String, condition: String?, catalogProductID: String?, permalink: String, buyingMode: String?, siteID: String?, categoryID: String?, domainID: String?, thumbnail: String, currencyID: String, price: Float, attributes: [Attribute], pictures: [Picture]?) {
        self.id = id
        self.title = title
        self.condition = condition
        self.catalogProductID = catalogProductID
        self.permalink = permalink
        self.buyingMode = buyingMode
        self.siteID = siteID
        self.categoryID = categoryID
        self.domainID = domainID
        self.thumbnail = thumbnail
        self.currencyID = currencyID
        self.price = price
        self.attributes = attributes
        self.pictures = pictures
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, condition
        case catalogProductID = "catalog_product_id"
        case permalink
        case buyingMode = "buying_mode"
        case siteID = "site_id"
        case categoryID = "category_id"
        case domainID = "domain_id"
        case thumbnail
        case currencyID = "currency_id"
        case price
        case attributes
        case pictures
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        condition = try values.decode(String?.self, forKey: .condition)
        catalogProductID = try values.decode(String?.self, forKey: .catalogProductID)
        permalink = try values.decode(String.self, forKey: .permalink)
        buyingMode = try values.decode(String.self, forKey: .buyingMode)
        siteID = try values.decode(String.self, forKey: .siteID)
        categoryID = try values.decode(String.self, forKey: .categoryID)
        domainID = try values.decode(String.self, forKey: .domainID)
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        currencyID = try values.decode(String.self, forKey: .currencyID)
        price = try values.decode(Float.self, forKey: .price)
        attributes = try values.decode([Attribute].self, forKey: .attributes)
        pictures = try values.decodeIfPresent([Picture].self, forKey: .pictures)

    }
}



// MARK: - Attribute
struct Attribute: Codable {
    let name, valueName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case valueName = "value_name"
    }
    
    init(name: String, valueName: String) {
        self.name = name
        self.valueName = valueName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String?.self, forKey: .name)
        valueName = try values.decode(String?.self, forKey: .valueName)
    }
}

// MARK: - Picture
struct Picture: Codable {
    let url: String
    let secureURL: String

    init(url: String, secureURL: String) {
        self.url = url
        self.secureURL = secureURL
    }
    enum CodingKeys: String, CodingKey {
        case url
        case secureURL = "secure_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
        secureURL = try values.decode(String.self, forKey: .secureURL)
    }
}
