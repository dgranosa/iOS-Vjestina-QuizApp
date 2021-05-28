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
    private var gradiantLayer: CAGradientLayer!
    
    convenience init(router: AppRouter) {
        self.init()
        
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradiantLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradiantLayer.frame = view.bounds
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        LoginButton(self)
        return true
    }
}
