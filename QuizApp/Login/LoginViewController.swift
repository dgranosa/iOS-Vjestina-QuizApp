//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 10.04.2021..
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    let networkService = NetworkService()
    private var router: AppRouter!
    
    convenience init(router: AppRouter) {
        self.init()
        
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoginButton(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        networkService.login(email: username, password: password, completionHandler: { [self] (result: Result<LoginStatus, RequestError>) in
            switch result {
            case .failure(let error):
                var errorMessage: String
                
                switch error {
                case .noConnectionError:
                    noConnectionAlert()
                    errorMessage = "No internet connection"
                case .serverError:
                    errorMessage = "Wrong username or password"
                case .clientError, .decodingError, .noDataError:
                    errorMessage = "Fetching error"
                }
                
                DispatchQueue.main.async {
                    statusLabel.text = errorMessage
                    statusLabel.alpha = 0
                    statusLabel.isHidden = false
                    UIView.animate(withDuration: 0.3, animations: {
                        self.statusLabel.alpha = 1
                    })
                }
            case .success(let loginStatus):
                let userDefaults = UserDefaults.init()
                userDefaults.set(loginStatus.token, forKey: "token")
                userDefaults.set(loginStatus.userId, forKey: "userId")
                
                DispatchQueue.main.async {
                    router.showTab()
                }
            }
        })
    }
    
    @IBAction func HideStatus(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.statusLabel.alpha = 0
        }) { (finished) in
            self.statusLabel.isHidden = true
        }
    }
}
