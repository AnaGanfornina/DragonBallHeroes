//
//  NetworkModel.swift
//  DragonBallHeroes2
//
//  Created by Ana on 16/3/25.
//

import Foundation

final class NetworkModel {
    
    static let shared = NetworkModel(client: APIClient.shared)
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let client: APIClientProtocol
    var token : String?
    
    init(client: APIClientProtocol) {
        self.client = client
    }
    
    // MARK: -  metodo para hacer  login
    
    /// Método para hacer login
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, APIClientError>) -> Void)
    {
        // Configuramos el path, la url
        var components = baseComponents
        components.path = "/api/auth/login"
        
        //vamos a desempaquetar la url, por si acaso la que le hemos pasado no fuera válida
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // Componer el string en base al usuario y la contraseña, para pasarselo al setValue
        let loginString = String(format: "%@:%@", user, password)
        
        // Encodifico el loginString a un data con utf8
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingAuthorizationFailed))
            return
        }
        
        // la codificamos en base 64
        let base64LoginData = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        client.jwt(request) { [weak self] result in
            switch result {
            case let .success(token):
                self?.token = token
            case .failure:
                break // TODO: Poner algun tipo de error pues se va por aqui cuando pones correo y contraseña incorrectas
            }
            completion(result)
        }
        
    }
    
    // MARK: - Método para obtener un json de heroes
    
    /// Método para obtener un json de heroes
    func getHeroes(completion: @escaping (Result<[Hero], APIClientError>) -> Void){
        
        // Configuramos el path, la url
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url =  components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let token else {
            completion(.failure(.tokenUnwrappingFailed))
            return
        }
        
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["name": ""]) else {
            completion(.failure(.encodingFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = serializedBody
        
        // para obtener los datos llamamos al request de Apiclient
        
        client.request(request, using: [Hero].self, completion: completion)
    }
    
    // MARK: - Método para obtener un json de transformaciones
    
    ///Método para obtener un json de transformaciones
    func getTransformations(
        for hero: Hero,
        completion: @escaping (Result<[Transformation], APIClientError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let token else {
            completion(.failure(.unknown))
            return
        }
        
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["id": hero.id]) else {
            completion(.failure(.decodingFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; chaset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = serializedBody
        
        client.request(request, using: [Transformation].self, completion: completion)
    }
    
}
