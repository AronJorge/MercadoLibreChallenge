//
//  RequestModel.swift
//  Weather Webcat
//
//  Created by Jorge Gutierrez on 19/03/23.
//

import Foundation

struct RequestModel  {
    let endpoint : Endpoints
    let httpMethod : HttpMethod = .GET
    var baseUrl : URLBase = .mercadoLibreApi
    
    func getURL() -> String{
        return baseUrl.rawValue + endpoint.rawValue
    }
    
    enum HttpMethod : String{
        case GET
        case POST
    }
    
    enum Endpoints  {
        case sites
        case search(siteId: String, query: String)
        case items(itemId: String)
        case empty
        
        var rawValue: String {
            switch self {
            case .sites:
                return "/sites"
            case .search(let siteId, let query):
                return "/sites/\(siteId)/search?q=\(query)"
            case .items(let itemId):
                return "/items/\(itemId)"
            case .empty:
                return ""
            }
        }
    }
    
    enum URLBase : String{
        case mercadoLibreApi = "https://api.mercadolibre.com"
        case empty = ""
    }
}
