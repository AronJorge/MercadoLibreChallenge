//
//  UserPreferences.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import Foundation

struct UserPreferences {
    static func saveSiteId(_ id: String) {
        UserDefaults.standard.set(id, forKey: Constants.preferenceKey.siteSelected)
    }
    
    static func getSiteId() -> String? {
        return UserDefaults.standard.string(forKey: Constants.preferenceKey.siteSelected)
    }
}

