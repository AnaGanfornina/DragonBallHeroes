//
//  APIClient.swift
//  DragonBallHeroes
//
//  Created by Ana on 11/3/25.
//

import Foundation

enum APIClientError: Error {
    case malformedURL
    case noData
    case statusCode(code: Int?)
    case decodingFailed
    case encodingFailed
    case decodingAuthorizationFailed
    case tokenUnwrappingFailed
    case unknown
}

struct APIClient {
    
    // Creacion de un singleton
    static let shared = APIClient()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Método jwt para obtener el token
    
    /// Método por el cual vamos a obtener el JWT de la API a traves del URLRequest
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, APIClientError>) -> Void
    ){
        // Obtiene de forma asíncrona los datos de la request
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // Si hay un error lo envio al completion, que lo ejecutará
                if let error = error as? NSError {
                    completion(.failure(.statusCode(code: error.code)))
                } else {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            
            let response = response as? HTTPURLResponse
            
            guard let response, response.statusCode == 200 else {
                completion(.failure(.statusCode(code: response?.statusCode)))
                return
            }
            
            // Desempaquetamos el data(token) para codificarlo a un string
            guard let jwt = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(jwt))
        }
        
        task.resume()
    }
    
    // MARK: - Método request para obtener de forma asíncrona datos
    
    /// Método que obtiene de forma asíncrona datos
    func request<T:Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, APIClientError>) -> Void
    ){
        // Obtiene de forma asíncrona los datos de la request
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // Si hay un error lo envio al completion, que lo ejecutará
                if let error = error as? NSError {
                    completion(.failure(.statusCode(code: error.code)))
                } else {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            
            let response = response as? HTTPURLResponse
            
            guard let response, response.statusCode == 200 else {
                completion(.failure(.statusCode(code: response?.statusCode)))
                return
            }
            
            guard let decodeModel = try?JSONDecoder().decode(using, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(decodeModel))
            
            
        }
        
        task.resume()
    }
}



