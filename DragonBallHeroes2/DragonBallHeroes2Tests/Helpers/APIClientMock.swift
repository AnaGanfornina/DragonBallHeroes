//
//  APIClientMock.swift
//  DragonBallHeroes2
//
//  Created by Ana on 16/3/25.
//

import Foundation


@testable import DragonBallHeroes2

final class APIClientMock: APIClientProtocol {
    
    var didCallJWT = false
    var receivedTokenRequest: URLRequest?
    var receivedTokenResult: Result<String, APIClientError>?
    
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, APIClientError>
        ) -> Void) {
        didCallJWT = true // comprobamos que se ha hecho la llamada para obtener el jwt
        receivedTokenRequest = request // lo que nos devuelva la llamada lo metemos aqui, será una url
        
        if let result = receivedTokenResult {
            completion(result)  // si conseguimos desempaquetarlo le enviamos el resultado mediate completion
        }
    }
    
    var didCallRequest = false
    var receivedRequest: URLRequest?
    var recivedHeroRsult: Result<[Hero], APIClientError>?
    var recivedTransformationResult: Result<[Transformation], APIClientError>?
    
    func request<T>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, APIClientError>) -> Void
    ) where T : Decodable {
        
        didCallRequest = true
        receivedRequest = request
        
        if let heroResult = recivedHeroRsult as? Result<T, APIClientError> {
            completion(heroResult)
            return
        }
        
        if let transformationResult = recivedTransformationResult as? Result<T, APIClientError> {
            completion(transformationResult)
            return
        }
    }
}

