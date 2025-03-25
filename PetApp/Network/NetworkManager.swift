//
//  NetworkManager.swift
//  PetApp
//
//  Created by 정성윤 on 3/21/25.
//

import Foundation
import Alamofire

protocol NetworkManagerType: AnyObject {
    func fetchData<T:Decodable,U:Router>(_ api: U) async throws -> T
}

final class NetworkManager: NetworkManagerType {
    static let shared: NetworkManagerType = NetworkManager()
    
    private init() { }
    
    func fetchData<T:Decodable,U:Router>(_ api: U) async throws -> T {
        let network = AF.request(api).validate(statusCode: 200...499)
        let response = network.serializingDecodable(T.self)
        
//        print(await response.response.debugDescription)
        switch await response.result {
        case let .success(data):
            return data
        case let .failure(error):
            //TODO: Custom Error
            throw error
        }
    }
}
