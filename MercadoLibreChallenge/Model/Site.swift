//
//  Site.swift
//  MercadoCasiLibre
//
//  Created by Victor Chirino on 22/07/2022.
//

import Foundation


struct Site: Decodable {
    var id: String
    var name: String
    var currency: String
    
    init(id: String, name: String, currency: String) {
        self.id = id
        self.name = name
        self.currency = currency
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case currency = "default_currency_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        currency = try values.decode(String.self, forKey: .currency)
    }
}
