//
//  DragonBallHeroes2Tests.swift
//  DragonBallHeroes2Tests
//
//  Created by Ana on 16/3/25.
//

import XCTest
@testable import DragonBallHeroes2

final class NetworkModelTest: XCTestCase {
    
     private var sut: NetworkModel!
     private var apiClient: APIClientMock! // Controlo mi dependencia con el mock
     
     //se va a ejecutar una vez por cada test
     override func setUp(){
         super.setUp()
         apiClient = APIClientMock()
         sut = NetworkModel(client: apiClient)// Le paso el mock y se la inyecto al NetworkModel
         sut.token = "some-token" // controlamos el token
     }
     
     // Vamos a controlar cuando hagamos la petición al servidor y nos devuelva un succes
     func test_getHeroes_emptyHeroes_success() {
         
         // Given
         let successResult = Result<[Hero], APIClientError>.success([]) // Esto no es exactamentr lo que nos devuelve la api, pero ahora nos vale
         
         apiClient.recivedHeroRsult = successResult // El mock simula una respuesta satisfactoria del request
         
         // When
         
         var recivedResult: Result<[Hero], APIClientError>?  // variable para almacenar el resultado de getHeroes
         sut.getHeroes { result in  // comprobamos que la closure de getHero se ejecuta correctamente tras que esta use los datos del mock
             recivedResult = result
         }
         
         // Then
         
         XCTAssertEqual(successResult, recivedResult)
         XCTAssertEqual(apiClient.receivedRequest?.url,
                        URL(string: "https://dragonball.keepcoding.education/api/heros/all")
         )
         let authorizationHeaderValue = apiClient.receivedRequest?.allHTTPHeaderFields?["Authorization"]
         XCTAssertEqual(authorizationHeaderValue, "Bearer some-token")
     }
     
     func test_getTransformation_emptyTransformation_success() {
         
         // Given
         let heroDePrueba = Hero(id: "1", name: "HeroeDePrueba", favorite: false, photo: "sinFoto", description: "SinDescripcion")
         let successResult = Result<[Transformation], APIClientError>.success([])
         apiClient.recivedTransformationResult = successResult
         
         // When
         var recivedResult: Result<[Transformation], APIClientError>?
         sut.getTransformations(for: heroDePrueba) { result in
             recivedResult = result
         }
         
         // Then
         XCTAssertEqual(successResult, recivedResult)
     }
     func test_login_success() {
         // Given
         let token = "TokenDePrueba"
         
         let successResult = Result<String, APIClientError>.success(token) // Simulamos la devolución de un token correcto, de forma que luego da igual que usuario o contraseña le introduzcamos
         apiClient.receivedTokenResult = successResult
         
         // When
         var recivedResult: Result<String, APIClientError>?
         sut.login(user: "User", password: "Password") { result in
             recivedResult = result
         }
         
         // Then
         XCTAssertEqual(successResult, recivedResult)
         
     }
}
