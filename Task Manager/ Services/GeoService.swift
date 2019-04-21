//
//  GeoService.swift
//  Task Manager
//
//  Created by Victor Blokhin on 05/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import Foundation

enum ServiceResult<Value> {
    case success(Value)
    case failure(Error)
}

struct GeoResult:Codable {
    struct Response:Codable {
        enum CodingKeys: String, CodingKey { case geoObjectCollection = "GeoObjectCollection" }
        struct GeoObjectCollection:Codable {
            struct FeatureMember:Codable {
                enum CodingKeys: String, CodingKey { case geoObject = "GeoObject" }
                struct GeoObject:Codable {
                    let name: String?
                }
                let geoObject: GeoObject?
            }
            let featureMember: [FeatureMember]?
        }
        let geoObjectCollection: GeoObjectCollection?
    }
    let response: Response?
    
    var address:String? {
        get {
            return response?.geoObjectCollection?.featureMember?[0].geoObject?.name
        }
    }
}

// https://geocode-maps.yandex.ru/1.x/?apikey=<Ваш API-ключ>&geocode=37.611347,55.760241

class GeoService {
    
    private enum Constants {
        static let apikey = "a0210eb1-789e-4403-b3cb-eaaee6a25891"
        static let baseURL = "https://geocode-maps.yandex.ru/1.x"
        static let error = NSError(domain: "GeoService", code: 0, userInfo: nil)
    }
    
    func obtainAddress(lat:Double, lon:Double, completion:((ServiceResult<GeoResult>) -> Void)?) {
        var urlComponents = URLComponents(string: Constants.baseURL)!
        let apiKey = URLQueryItem(name: "apikey", value: Constants.apikey)
        
        let coordString = "\(lon),\(lat)"
        let coords = URLQueryItem(name: "geocode", value: coordString)
        let resultsCount = URLQueryItem(name: "results", value: "1")
        let respFormat = URLQueryItem(name: "format", value: "json")
        urlComponents.queryItems = [apiKey, coords, resultsCount, respFormat]
        
        var request  = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard error == nil else {
                completion?(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion?(.failure(Constants.error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GeoResult.self, from: data)
                completion?(.success(result))
            } catch let error {
                completion?(.failure(error))
            }
        }
        
        task.resume()
        
    }
}
