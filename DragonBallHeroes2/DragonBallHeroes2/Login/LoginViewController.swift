//
//  LoginViewController.swift
//  DragonBallHeroes
//
//  Created by Ana on 11/3/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Button Acction
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        
        // convertimos el contenido de los field en strings
        
        guard let usernameTextFieldString = usernameTextField.text,
              let passwordTextFieldString = passwordTextField.text else {
            return
        }
        
        let networkModel = NetworkModel.shared
        
        // Obtenemos el JWTllamando al login
        
        networkModel.login(
            user: usernameTextFieldString,
            password: passwordTextFieldString) { [weak self] result in
                switch result {
                case .success:
                    
                    //Navegamos hacia el HeroList
                    
                    
                    DispatchQueue.main.async { // TODO: Aquí va un weak self ??
                        
                        let heroLisTableViewController = HeroListTableViewController()
                        self?.navigationController?.setViewControllers([heroLisTableViewController], animated: true)
                    }
 
                case .failure(let error):
                    print(error)
                }
            }
    }
    


}
