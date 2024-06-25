//
//  APIConnection.swift
//  MercadoLibreChallenge2
//
//  Created by Jorge Gutierrez on 22/06/24.
//

import Foundation


@MainActor
class APIConnection {
    static func callService<T: Decodable>(_ requestModel: RequestModel, _ modelType: T.Type) async throws -> T{

        let serviceUrl = URLComponents(string: requestModel.getURL())
        
        guard let componentURL = serviceUrl?.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.httpMethod.rawValue
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print(request.url as Any)
            guard let httpResponse = response as? HTTPURLResponse else{
                throw NetworkError.httpResponseError
            }
            
            if (httpResponse.statusCode > 299){
                throw NetworkError.statusCodeError
            }
            
            let decoder = JSONDecoder()
            do{
                let decodeData = try decoder.decode(T.self, from: data)
                return decodeData
            }catch{
                print("error: \(error)")
                throw NetworkError.couldNotDecodeData
            }
            
        }catch{
            print("error: \(error)")
            throw NetworkError.generic
        }
    }
    
    static func buildQueryItems(params: [String:String]) -> [URLQueryItem]{
        let items = params.map({URLQueryItem(name: $0, value: $1)})
        return items
    }
}
